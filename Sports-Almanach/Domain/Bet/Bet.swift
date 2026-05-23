//
//  Bet.swift
//  Sports-Almanach
//
//  Domain model — replaces Data/Models/Bet.swift.
//
//  Important shift from the legacy model:
//
//  - The legacy `Bet` stored a full `Event` value reference. When BetRepository
//    reconstructed a historic bet, it refetched the entire season from the
//    SportsDB API just to look up that event. To stop that N+1 explosion this
//    model embeds an immutable `EventSnapshot` — enough information to render
//    the bet history without further network round-trips.
//
//  - `userTip` previously used a football-specific 1X2 enum, breaking other
//    sports. We now store an `AnyOutcome` carrying a stable identifier plus
//    display name, decoupling Bet from any one sport's outcome layout.
//
//  - `odds` is a `Decimal` so all payout math stays exact.
//
//  - `BetStatus` replaces the boolean `isWon` so we can express the difference
//    between "match not played yet" (.pending) and "match played and we lost"
//    (.lost). The legacy boolean conflated the two.
//

import Foundation

public struct Bet: Identifiable, Codable, Hashable, Sendable {

    public let id: UUID
    public let event: EventSnapshot
    public let userTip: AnyOutcome
    public let odds: Decimal
    public let placedAt: Date
    public var status: BetStatus
    /// Filled in once `BettingEvaluator` resolves a pending bet.
    public var winAmount: Money?

    public init(id: UUID = UUID(),
                event: EventSnapshot,
                userTip: AnyOutcome,
                odds: Decimal,
                placedAt: Date = Date(),
                status: BetStatus = .pending,
                winAmount: Money? = nil) {
        self.id = id
        self.event = event
        self.userTip = userTip
        self.odds = odds
        self.placedAt = placedAt
        self.status = status
        self.winAmount = winAmount
    }
}

/// Embedded snapshot of an event so a historical bet renders without a
/// new API call. We capture enough to display the row: teams, league, date.
public struct EventSnapshot: Codable, Hashable, Sendable {
    public let eventID: String
    public let name: String
    public let leagueName: String
    public let sport: String
    public let homeTeam: String
    public let awayTeam: String
    /// ISO 8601 — keeps it parseable across locales without hand-rolled formats.
    public let kickoffISO: String

    public init(eventID: String,
                name: String,
                leagueName: String,
                sport: String,
                homeTeam: String,
                awayTeam: String,
                kickoffISO: String) {
        self.eventID = eventID
        self.name = name
        self.leagueName = leagueName
        self.sport = sport
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.kickoffISO = kickoffISO
    }
}
