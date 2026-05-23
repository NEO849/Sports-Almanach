//
//  Outcome.swift
//  Sports-Almanach
//
//  Sport-agnostic outcome model. The legacy `UserTip` / `EventResult` enums
//  hard-coded 1X2 (home win / draw / away win) which only matches football.
//  For tennis, basketball, etc. there is no "draw" outcome — the previous
//  model silently misrepresented those sports.
//
//  This file defines the outcome contract; per-sport conformances live
//  alongside the Sport enum.
//

import SwiftUI

/// A potential result of a match that a user can wager on.
/// Concrete outcomes (`MatchOutcome.homeWin` etc.) live below.
public protocol Outcome: Hashable, Codable, Sendable {
    var stableID: String { get }
    var displayName: String { get }
    var swatch: Color { get }
}

/// The classic football 1X2 outcome. Reused for any team-vs-team sport that
/// allows draws (football, ice hockey regular time, cricket, ...).
public enum MatchOutcome: String, Outcome, CaseIterable {
    case homeWin
    case draw
    case awayWin

    public var stableID: String { rawValue }

    public var displayName: String {
        switch self {
        case .homeWin: return NSLocalizedString("outcome.homeWin", value: "1 (Home win)", comment: "")
        case .draw:    return NSLocalizedString("outcome.draw",    value: "X (Draw)",     comment: "")
        case .awayWin: return NSLocalizedString("outcome.awayWin", value: "2 (Away win)", comment: "")
        }
    }

    public var swatch: Color {
        switch self {
        case .homeWin: return AppTheme.Colors.homeWin
        case .draw:    return AppTheme.Colors.draw
        case .awayWin: return AppTheme.Colors.awayWin
        }
    }

    /// Map a final score to the outcome it produced. Returns nil when the
    /// match has not concluded (or no score is available).
    public static func from(homeScore: Int?, awayScore: Int?) -> MatchOutcome? {
        guard let home = homeScore, let away = awayScore else { return nil }
        if home > away { return .homeWin }
        if home < away { return .awayWin }
        return .draw
    }
}

/// Outcome for sports without a draw (tennis, most basketball, MMA, ...).
public enum BinaryOutcome: String, Outcome, CaseIterable {
    case homeWin
    case awayWin

    public var stableID: String { rawValue }

    public var displayName: String {
        switch self {
        case .homeWin: return NSLocalizedString("outcome.homeWin", value: "1 (Home win)", comment: "")
        case .awayWin: return NSLocalizedString("outcome.awayWin", value: "2 (Away win)", comment: "")
        }
    }

    public var swatch: Color {
        switch self {
        case .homeWin: return AppTheme.Colors.homeWin
        case .awayWin: return AppTheme.Colors.awayWin
        }
    }
}

/// Type-erased outcome stored inside a Bet, so the model can hold any sport's
/// outcome without conditional compile-time gymnastics on the caller side.
public struct AnyOutcome: Hashable, Codable, Sendable {
    public let stableID: String
    public let displayName: String

    public init<O: Outcome>(_ outcome: O) {
        self.stableID = outcome.stableID
        self.displayName = outcome.displayName
    }

    public init(stableID: String, displayName: String) {
        self.stableID = stableID
        self.displayName = displayName
    }
}
