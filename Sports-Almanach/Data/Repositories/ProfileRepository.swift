//
//  ProfileRepository.swift
//  Sports-Almanach
//
//  Concrete ProfileRepository backed by Firestore. Replaces the legacy file
//  that exposed `emailExists(...)`. We removed the email lookup intentionally:
//  it was an information-disclosure vector (allowed any unauthenticated
//  client to enumerate registered emails). Firebase Auth already raises
//  `emailAlreadyInUse` on signUp — that is the canonical signal.
//

import Foundation
import FirebaseFirestore

public final class ProfileRepository: ProfileRepositoryProtocol, @unchecked Sendable {

    private let firestore: Firestore

    public init(firestore: Firestore = .firestore()) {
        self.firestore = firestore
    }

    public func createProfile(_ profile: Profile) async throws {
        try profilesCollection.document(profile.id).setData(from: profile)
    }

    public func loadProfile(userID: String) async throws -> Profile? {
        let snapshot = try await profilesCollection.document(userID).getDocument()
        return try? snapshot.data(as: Profile.self)
    }

    public func loadAllProfiles() async throws -> [Profile] {
        let snapshot = try await profilesCollection.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Profile.self) }
    }

    public func updateBalance(userID: String, newBalance: Money) async throws {
        let encoded = try Firestore.Encoder().encode(newBalance)
        try await profilesCollection.document(userID).updateData([
            "balance": encoded
        ])
    }

    public func updateLastBirthdayBonusYear(userID: String, year: Int) async throws {
        try await profilesCollection.document(userID).updateData([
            "lastBirthdayBonusYear": year
        ])
    }

    private var profilesCollection: CollectionReference {
        firestore.collection(AppConstants.FirestoreCollections.profiles)
    }
}
