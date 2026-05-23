//
//  AuthServiceProtocol.swift
//  Sports-Almanach
//
//  Sits between the FirebaseAuth SDK and the rest of the app. Provides an
//  AsyncStream of the current user so SwiftUI can drive its top-level routing
//  off a true observable source — replacing the legacy app's static
//  `FirebaseAuthManager.shared.isUserSignedIn` snapshot which was read once
//  at scene creation and never refreshed.
//

import Foundation

public protocol AuthServiceProtocol: AnyObject, Sendable {
    /// Current cached user, if any. Synchronous accessor used at very-first
    /// view creation; UI should listen to `userStream` for ongoing changes.
    var currentUser: SportsAlmanachUser? { get }

    /// Async sequence of auth state changes. Each yield reflects sign-in or
    /// sign-out events from Firebase Auth.
    func userStream() -> AsyncStream<SportsAlmanachUser?>

    func signUp(email: String, password: String) async throws -> SportsAlmanachUser
    func signIn(email: String, password: String) async throws -> SportsAlmanachUser
    func signOut() throws
}
