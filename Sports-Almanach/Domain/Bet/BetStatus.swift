//
//  BetStatus.swift
//  Sports-Almanach
//
//  Lifecycle state machine for a single bet and for the wettschein that
//  contains it. The legacy code resolved bets *at placement time* by reading
//  the event's score — but for future matches the score is nil and the bet
//  was therefore always marked "lost" instantly. Future bets are now first-
//  class: they sit in `.pending` until the event has a final score, and the
//  `BettingEvaluator` resolves them in batch on app launch.
//

import Foundation

public enum BetStatus: String, Codable, Sendable, CaseIterable {
    /// Match not yet played — score unknown.
    case pending
    /// Outcome matched the user's tip.
    case won
    /// Outcome did not match.
    case lost
    /// Match was cancelled / postponed / no score available — stake refunded.
    case void

    public var isTerminal: Bool { self != .pending }

    public var displayName: String {
        switch self {
        case .pending: return NSLocalizedString("bet.status.pending", value: "Pending",  comment: "")
        case .won:     return NSLocalizedString("bet.status.won",     value: "Won",      comment: "")
        case .lost:    return NSLocalizedString("bet.status.lost",    value: "Lost",     comment: "")
        case .void:    return NSLocalizedString("bet.status.void",    value: "Voided",   comment: "")
        }
    }
}

public enum BetSlipStatus: String, Codable, Sendable, CaseIterable {
    /// At least one contained bet is still pending.
    case pending
    /// All bets resolved and every single one was won.
    case won
    /// All bets resolved and at least one was lost.
    case lost
    /// All bets either won or void, none lost — payout reduced accordingly.
    case partiallyWon

    public var isTerminal: Bool { self != .pending }

    public var displayName: String {
        switch self {
        case .pending:        return NSLocalizedString("betslip.status.pending",        value: "Pending",        comment: "")
        case .won:            return NSLocalizedString("betslip.status.won",            value: "Won",            comment: "")
        case .lost:            return NSLocalizedString("betslip.status.lost",            value: "Lost",           comment: "")
        case .partiallyWon:    return NSLocalizedString("betslip.status.partiallyWon",    value: "Partially won",  comment: "")
        }
    }
}
