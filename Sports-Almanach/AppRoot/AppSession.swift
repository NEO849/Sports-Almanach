//
//  AppSession.swift
//  Sports-Almanach
//
//  Top-level observable session state — single source of truth used by
//  Sports_AlmanachApp.swift to route between Splash, Onboarding and the main
//  TabView. Replaces the legacy approach of reading
//  `FirebaseAuthManager.shared.isUserSignedIn` directly inside `WindowGroup`,
//  which was a non-observable snapshot evaluated once at scene creation.
//

import Foundation
import SwiftUI

/// Lifecycle phase visible to the App entry point. Driven by the auth stream.
public enum SessionPhase: Equatable {
    case bootstrapping
    case unauthenticated
    case authenticated(SportsAlmanachUser)
}

@MainActor
public final class AppSession: ObservableObject {

    @Published public private(set) var phase: SessionPhase = .bootstrapping
    @Published public private(set) var lastError: String?

    private let authService: AuthServiceProtocol
    private var streamTask: Task<Void, Never>?

    public init(authService: AuthServiceProtocol) {
        self.authService = authService
        observe()
    }

    deinit {
        streamTask?.cancel()
    }

    public var currentUser: SportsAlmanachUser? {
        if case .authenticated(let user) = phase { return user }
        return nil
    }

    public func signOut() {
        do {
            try authService.signOut()
        } catch {
            lastError = error.localizedDescription
        }
    }

    public func signIn(email: String, password: String) async -> Result<SportsAlmanachUser, Error> {
        do {
            let user = try await authService.signIn(email: email, password: password)
            return .success(user)
        } catch {
            await MainActor.run { self.lastError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription }
            return .failure(error)
        }
    }

    public func signUp(email: String, password: String) async -> Result<SportsAlmanachUser, Error> {
        do {
            let user = try await authService.signUp(email: email, password: password)
            return .success(user)
        } catch {
            await MainActor.run { self.lastError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription }
            return .failure(error)
        }
    }

    public func clearError() { lastError = nil }

    private func observe() {
        let stream = authService.userStream()
        streamTask = Task { [weak self] in
            for await user in stream {
                guard let self else { return }
                await MainActor.run {
                    if let user {
                        self.phase = .authenticated(user)
                    } else {
                        self.phase = .unauthenticated
                    }
                }
            }
        }
    }
}

#if DEBUG
extension AppSession {
    /// Authenticated session for Canvas previews — no Firebase, no live stream.
    static func preview(user: SportsAlmanachUser = PreviewData.user) -> AppSession {
        let session = AppSession(authService: PreviewAuthService(user: user))
        session.phase = .authenticated(user)
        return session
    }
}
#endif
