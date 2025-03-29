//
//  FirestoreRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps
//

import Foundation
import FirebaseFirestore

/// Zentrale Stelle für alle Crud-Datenbankoperationen
class ProfileRepository {
    /// Firestore-Datenbankinstanz für alle Operationen
    private let dbInstanz = Firestore.firestore()
    
    // MARK: - Profil-Operationen
    /// Wird bei Registrierung und Profiländerungen verwendet
    func saveProfile(_ profile: Profile, userId: String) async throws {
        try dbInstanz.collection("Profile").document(userId).setData(from: profile)
    }
    
    /// Lädt ein Benutzerprofil aus Firestore
    func loadProfile(userId: String) async throws -> Profile? {
        do {
            let snapshot = try await dbInstanz.collection("Profile")
                .document(userId)
                .getDocument()
            
            let profile = try? snapshot.data(as: Profile.self)
            print("📱 Profil geladen: \(String(describing: profile))")
            return profile
        } catch {
            print("❌ Fehler beim Laden des Profils: \(error)")
            throw error
        }
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
