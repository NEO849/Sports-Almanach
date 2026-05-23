//
//  Mocks.swift
//  Sports-Almanach
//
//  Centralized mock data for previews and tests, rewritten to match the new
//  Domain types (Decimal-Money, EventSnapshot, BetStatus, etc.).
//

import Foundation

public enum Mocks {

    // MARK: - Events
    public static let events: [Event] = [
        Event(
            id: "602129",
            name: "Liverpool vs Norwich",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2023-2024",
            homeTeam: "Liverpool",
            awayTeam: "Norwich",
            homeScore: 4,
            awayScore: 1,
            kickoffISO: "2024-08-09T19:00:00",
            date: "2024-08-09",
            time: "19:00:00",
            stadium: "Anfield",
            thumbnail: "https://www.thesportsdb.com/images/media/event/thumb/mv7oni1565190477.jpg",
            videoURL: "https://www.youtube.com/watch?v=5WWOpHQ1yJo",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/vwpvry1467462651.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/xtsxrt1421432888.png",
            status: .finished
        ),
        Event(
            id: "602130",
            name: "Crystal Palace vs Arsenal",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2023-2024",
            homeTeam: "Crystal Palace",
            awayTeam: "Arsenal",
            homeScore: 2,
            awayScore: 2,
            kickoffISO: "2024-08-10T16:00:00",
            date: "2024-08-10",
            time: "16:00:00",
            stadium: "Selhurst Park",
            thumbnail: "https://www.thesportsdb.com/images/media/event/thumb/cgbjmr1565361856.jpg",
            videoURL: nil,
            homeTeamBadge: nil,
            awayTeamBadge: nil,
            status: .finished
        ),
        Event(
            id: "602131",
            name: "Manchester City vs Tottenham",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2023-2024",
            homeTeam: "Manchester City",
            awayTeam: "Tottenham",
            homeScore: nil,
            awayScore: nil,
            kickoffISO: "2024-09-15T17:00:00",
            date: "2024-09-15",
            time: "17:00:00",
            stadium: "Etihad Stadium",
            thumbnail: "https://www.thesportsdb.com/images/media/event/thumb/5rncnc1566644537.jpg",
            videoURL: nil,
            homeTeamBadge: nil,
            awayTeamBadge: nil,
            status: .scheduled
        )
    ]

    // MARK: - Bets
    public static let bets: [Bet] = events.enumerated().map { idx, event in
        Bet(
            id: UUID(),
            event: event.snapshot,
            userTip: AnyOutcome(MatchOutcome.allCases[idx % MatchOutcome.allCases.count]),
            odds: Decimal(string: ["1.80", "3.50", "4.20"][idx % 3]) ?? 2.0,
            status: idx == 0 ? .won : (idx == 1 ? .pending : .lost),
            winAmount: idx == 0 ? Money(18) : nil
        )
    }

    // MARK: - BetSlips
    public static let betSlips: [BetSlip] = [
        BetSlip(
            userID: "user1",
            slipNumber: 1,
            bets: [bets[0]],
            stake: Money(10),
            status: .won,
            winAmount: Money(18)
        ),
        BetSlip(
            userID: "user2",
            slipNumber: 2,
            bets: [bets[1]],
            stake: Money(10),
            status: .pending
        ),
        BetSlip(
            userID: "user3",
            slipNumber: 3,
            bets: [bets[2]],
            stake: Money(10),
            status: .lost
        )
    ]

    // MARK: - Profiles
    public static let profiles: [Profile] = [
        Profile(id: "user1", username: "Max",  email: "max@example.com",  birthday: Date(timeIntervalSince1970: 631152000), balance: Money(1500)),
        Profile(id: "user2", username: "Anna", email: "anna@example.com", birthday: Date(timeIntervalSince1970: 662688000), balance: Money(800)),
        Profile(id: "user3", username: "Theo", email: "theo@example.com", birthday: Date(timeIntervalSince1970: 725760000), balance: Money(2200))
    ]
}
