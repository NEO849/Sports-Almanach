//
//  FirebaseAuthService.swift
//  Sports-Almanach
//
//  Concrete AuthServiceProtocol on top of FirebaseAuth.
//
//  Why this replaces FirebaseAuthManager:
//
//  - The legacy `FirebaseAuthManager.shared` exposed `isUserSignedIn` as a
//    plain Bool. SwiftUI read it once at scene creation and never re-evaluated;
//    sign-in events did not flip the UI without manual workarounds.
//
//  - This service exposes the auth state through an `AsyncStream`, so the
//    root view can drive routing off an authoritative async sequence.
//

import Foundation
import FirebaseAuth

public final class FirebaseAuthService: AuthServiceProtocol, @unchecked Sendable {

    private let auth: Auth
    private var listenerHandle: AuthStateDidChangeListenerHandle?
    private let observersLock = NSLock()
    private var observers: [UUID: (SportsAlmanachUser?) -> Void] = [:]

    public var currentUser: SportsAlmanachUser? {
        Self.map(auth.currentUser)
    }

    public init(auth: Auth = .auth()) {
        self.auth = auth
        self.listenerHandle = auth.addStateDidChangeListener { [weak self] _, user in
            self?.broadcast(Self.map(user))
        }
    }

    deinit {
        if let handle = listenerHandle {
            auth.removeStateDidChangeListener(handle)
        }
    }

    public func userStream() -> AsyncStream<SportsAlmanachUser?> {
        AsyncStream { continuation in
            let id = UUID()

            // Replay current state so consumers start with a value immediately.
            continuation.yield(currentUser)

            observersLock.lock()
            observers[id] = { user in
                continuation.yield(user)
            }
            observersLock.unlock()

            continuation.onTermination = { [weak self] _ in
                self?.observersLock.lock()
                self?.observers[id] = nil
                self?.observersLock.unlock()
            }
        }
    }

    public func signUp(email: String, password: String) async throws -> SportsAlmanachUser {
        let result = try await auth.createUser(withEmail: email, password: password)
        guard let mapped = Self.map(result.user) else { throw AppErrors.Auth.noEmail }
        AppLogger.info("signUp ok uid=\(mapped.id)", category: .auth)
        return mapped
    }

    public func signIn(email: String, password: String) async throws -> SportsAlmanachUser {
        let result = try await auth.signIn(withEmail: email, password: password)
        guard let mapped = Self.map(result.user) else { throw AppErrors.Auth.noEmail }
        AppLogger.info("signIn ok uid=\(mapped.id)", category: .auth)
        return mapped
    }

    public func signOut() throws {
        do {
            try auth.signOut()
            AppLogger.info("signOut ok", category: .auth)
        } catch {
            AppLogger.error("signOut failed: \(error.localizedDescription)", category: .auth)
            throw AppErrors.Auth.signOutFailed
        }
    }

    private func broadcast(_ user: SportsAlmanachUser?) {
        observersLock.lock()
        let snapshot = observers.values
        observersLock.unlock()
        snapshot.forEach { $0(user) }
    }

    private static func map(_ user: User?) -> SportsAlmanachUser? {
        guard let user, let email = user.email else { return nil }
        return SportsAlmanachUser(id: user.uid, email: email)
    }
}
