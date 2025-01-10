//
//  FirestoreRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps
//

import Foundation
import FirebaseFirestore

/// Zentrale Stelle für alle Firestore-Datenbankoperationen
class FirestoreRepository {
    /// Firestore-Datenbankinstanz für alle Operationen
    private let dbInstanz = Firestore.firestore()
    
    // MARK: - Profil-Operationen
    /// Wird bei Registrierung und Profiländerungen verwendet
    func saveProfile(_ profile: Profile, userId: String) async throws {
        try dbInstanz.collection("Profile").document(userId).setData(from: profile)
    }
    
    /// Lädt ein Benutzerprofil aus Firestore
    func loadProfile(userId: String) async throws -> Profile? {
        let snapshot = try await dbInstanz.collection("Profile").document(userId).getDocument()
        return try? snapshot.data(as: Profile.self)
    }
    
    /// Aktualisiert nur den Kontostand eines Benutzers
    /// Wird nach Wetten oder Bonusaktionen aufgerufen
    func updateBalance(userId: String, newBalance: Double) async throws {
        try await dbInstanz.collection("Profile").document(userId)
            .updateData(["balance": newBalance])
    }

    /// - Returns: true wenn die E-Mail bereits existiert
    func emailExists(_ email: String) async throws -> Bool {
        let snapshot = try await dbInstanz.collection("Profile")
            .whereField("email", isEqualTo: email)
            .getDocuments()
        return !snapshot.isEmpty
    }
}
