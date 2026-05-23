//
//  OddsCalculator.swift
//  Sports-Almanach
//
//  Pure odds derivation — extracted from the previous SportEventUtils so it
//  can be unit-tested in isolation. The legacy implementation lived inline
//  in a Utils struct and was reached only via `calculateOdds(for: event)`,
//  which made stubbing impossible.
//

import Foundation

public struct OddsBundle: Hashable, Sendable {
    public let homeWin: Decimal
    public let draw: Decimal
    public let awayWin: Decimal

    public init(homeWin: Decimal, draw: Decimal, awayWin: Decimal) {
        self.homeWin = homeWin
        self.draw = draw
        self.awayWin = awayWin
    }
}

public enum OddsCalculator {

    private static let minimumOdds: Decimal = 1.2
    private static let baseHomeOdds: Decimal = 2.0
    private static let baseAwayOdds: Decimal = 2.5
    private static let baseDrawOdds: Decimal = 3.0
    private static let blowoutDrawOdds: Decimal = 5.0

    /// Computes odds from already-known scores. For a not-yet-played match
    /// (both scores nil) the base odds are returned. For an in-progress match
    /// the legacy heuristic is preserved but with `Decimal` arithmetic.
    public static func odds(homeScore: Int?, awayScore: Int?) -> OddsBundle {
        guard let home = homeScore, let away = awayScore else {
            return OddsBundle(homeWin: baseHomeOdds, draw: baseDrawOdds, awayWin: baseAwayOdds)
        }
        if home == 0 && away == 0 {
            return OddsBundle(homeWin: baseHomeOdds, draw: baseDrawOdds, awayWin: baseAwayOdds)
        }
        let homeWin = max(minimumOdds, Decimal(away + 1) / Decimal(home + 1))
        let awayWin = max(minimumOdds, Decimal(home + 1) / Decimal(away + 1))
        let draw: Decimal = abs(home - away) <= 1 ? baseDrawOdds : blowoutDrawOdds
        return OddsBundle(homeWin: homeWin, draw: draw, awayWin: awayWin)
    }
}
