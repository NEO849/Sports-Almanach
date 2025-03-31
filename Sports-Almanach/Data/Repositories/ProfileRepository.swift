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
    
    /// Lädt alle Profile für die Rangliste
    func loadAllProfiles() async throws -> [Profile] {
        do {
            let snapshot = try await dbInstanz.collection("Profile")
                .getDocuments()
            
            let profiles = snapshot.documents.compactMap { document in
                try? document.data(as: Profile.self)
            }
            print("📱 \(profiles.count) Profile geladen")
            return profiles
        } catch {
            print("❌ Fehler beim Laden aller Profile: \(error)")
            throw error
        }
    }
    
    /// Aktualisiert nur den Kontostand eines Benutzers, wird nach Wetten oder Bonusaktionen aufgerufen
    func updateBalance(userId: String, newBalance: Double) async throws {
        try await dbInstanz.collection("Profile").document(userId)
            .updateData(["balance": newBalance])
    }

    func emailExists(_ email: String) async throws -> Bool {
        let snapshot = try await dbInstanz.collection("Profile")
            .whereField("email", isEqualTo: email)
            .getDocuments()
        return !snapshot.isEmpty
    }
}
