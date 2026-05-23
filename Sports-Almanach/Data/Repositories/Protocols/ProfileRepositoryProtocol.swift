//
//  ProfileRepositoryProtocol.swift
//  Sports-Almanach
//

import Foundation

public protocol ProfileRepositoryProtocol: AnyObject, Sendable {
    func createProfile(_ profile: Profile) async throws
    func loadProfile(userID: String) async throws -> Profile?
    func loadAllProfiles() async throws -> [Profile]
    /// Atomically update only the balance. Used by the birthday bonus path
    /// outside a betting transaction.
    func updateBalance(userID: String, newBalance: Money) async throws
    func updateLastBirthdayBonusYear(userID: String, year: Int) async throws
}
