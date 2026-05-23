//
//  BetSlip.swift
//  Sports-Almanach
//
//  Domain model — replaces Data/Models/BetSlip.swift.
//

import Foundation

public struct BetSlip: Identifiable, Codable, Hashable, Sendable {

    public let id: UUID
    public let userID: String
    /// Sequential number per user, surfaced in the UI as "# 12 Wettschein".
    public let slipNumber: Int
    public var bets: [Bet]
    public let createdAt: Date
    public let stake: Money
    public var status: BetSlipStatus
    /// Set once at least one bet wins. For full-win combos this equals stake × Π odds.
    public var winAmount: Money?

    public init(id: UUID = UUID(),
                userID: String,
                slipNumber: Int,
                bets: [Bet] = [],
                createdAt: Date = Date(),
                stake: Money,
                status: BetSlipStatus = .pending,
                winAmount: Money? = nil) {
        self.id = id
        self.userID = userID
        self.slipNumber = slipNumber
        self.bets = bets
        self.createdAt = createdAt
        self.stake = stake
        self.status = status
        self.winAmount = winAmount
    }

    /// Multiplicative combo odds. Used both for UI display before placement
    /// and for payout calculation once all bets resolve.
    public var totalOdds: Decimal {
        bets.reduce(Decimal(1)) { $0 * $1.odds }
    }

    /// Potential payout if every bet wins — `stake × totalOdds`.
    public var potentialWin: Money {
        (stake * totalOdds).rounded()
    }

    /// Recompute slip-level status from the contained bets' statuses.
    /// Pure function — used by `BettingEvaluator` after individual bets resolve.
    public func recomputedStatus() -> BetSlipStatus {
        guard !bets.isEmpty else { return .pending }
        if bets.contains(where: { $0.status == .pending }) { return .pending }
        if bets.allSatisfy({ $0.status == .won }) { return .won }
        if bets.contains(where: { $0.status == .lost }) { return .lost }
        // Mix of .won and .void with no .lost — counts as partial.
        return .partiallyWon
    }
}
