//
//  FirebaseAuthManager.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 08.10.24.
//

import Foundation
import FirebaseAuth
import Observation

/// Manages Firebase Authentication operations and user state
@Observable
class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()  //  Singleton
    private var user: User?
    var isUserSignedIn: Bool {
        user != nil
    }
    var userID: String? {
        user?.uid
    }
    
    // Firebase Auth instance
    private let auth = Auth.auth()
    private init() {
        checkAuth()
    }
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("Firebase: Not logged in")
            return
        }
        self.user = currentUser
    }
    
    // Registrieren, An,-Abmelden
    func signUp(email: String, password: String) async throws {
        let authResult = try await auth.createUser(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("Firebase: User with email '\(email)' is registered with id '\(authResult.user.uid)'")
        self.user = authResult.user
        try await signIn(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("Firebase: User with email '\(email)' signed in with id '\(authResult.user.uid)'")
        self.user = authResult.user
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user = nil
            print("Firebase: Sign out succeeded.")
        } catch {
            print("Firebase: Sign out failed.")
        }
    }
}
