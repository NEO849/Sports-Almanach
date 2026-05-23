//
//  BetRepositoryProtocol.swift
//  Sports-Almanach
//

import Foundation

public protocol BetRepositoryProtocol: AnyObject, Sendable {
    /// Atomically place a slip and debit the user's balance. Implementations
    /// are expected to use a Firestore transaction so the two writes succeed
    /// or fail together — eliminating the legacy race where money was deducted
    /// before the slip persisted.
    func placeSlip(_ slip: BetSlip, debiting stake: Money, from userID: String) async throws

    /// Load history descending by slip number.
    func loadSlips(userID: String) async throws -> [BetSlip]

    /// Stream of pending slips. `BettingEvaluator` calls this on app launch
    /// to settle any matches that have finished since the slip was placed.
    func loadPendingSlips(userID: String) async throws -> [BetSlip]

    /// Apply evaluator output: persist new statuses + payout per bet/slip,
    /// then credit the user's balance with the winning amount, transactionally.
    func settleSlip(_ slip: BetSlip, creditingTo userID: String) async throws

    /// Returns the next sequential slip number for the user (max existing + 1).
    func nextSlipNumber(forUser userID: String) async throws -> Int
}
