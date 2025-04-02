//
//  MockEvents.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

/// Zentrale Struktur für alle Mock-Daten der App
struct Mocks {
    
    // MARK: - Mock Events
    static let events: [Event] = [
        Event(
            id: "602129",
            name: "Liverpool vs Norwich",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Liverpool",
            awayTeam: "Norwich",
            date: "2019-08-09",
            time: "19:00",
            stadion: "Anfield",
            image: "https://www.thesportsdb.com/images/media/event/thumb/mv7oni1565190477.jpg",
            videoURL: "https://www.youtube.com/watch?v=5WWOpHQ1yJo",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/vwpvry1467462651.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/xtsxrt1421432888.png",
            statusString: "Not Started",
            homeScore: "4",
            awayScore: "1"
        ),
        Event(
            id: "602130",
            name: "Crystal Palace vs Arsenal",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Crystal Palace",
            awayTeam: "Arsenal",
            date: "2019-08-10",
            time: "16:00",
            stadion: "Selhurst Park",
            image: "https://www.thesportsdb.com/images/media/event/thumb/cgbjmr1565361856.jpg",
            videoURL: "https://www.youtube.com/watch?v=VuEb0SzUNaI",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/crystal_palace_badge.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/arsenal_badge.png",
            statusString: "Match Finished",
            homeScore: "2",
            awayScore: "2"
        ),
        Event(
            id: "602131",
            name: "Manchester City vs Tottenham",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Manchester City",
            awayTeam: "Tottenham",
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            image: "https://www.thesportsdb.com/images/media/event/thumb/5rncnc1566644537.jpg",
            videoURL: "https://www.youtube.com/watch?v=efgh5678",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/man_city_badge.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/tottenham_badge.png",
            statusString: "Match Finished",
            homeScore: "1",
            awayScore: "2"
        ),
        Event(
            id: "602132",
            name: "Westham vs Norwich",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Liverpool",
            awayTeam: "Norwich",
            date: "2019-08-09",
            time: "19:00:00",
            stadion: "Anfield",
            image: "https://www.thesportsdb.com/images/media/event/thumb/ibh8sg1565615267.jpg",
            videoURL: "https://www.youtube.com/watch?v=WzGN6uWqwQ4",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/west_ham_badge.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/norwich_badge.png",
            statusString: "In Progress",
            homeScore: "0",
            awayScore: "0"
        ),
        Event(
            id: "602133",
            name: "Tottenham vs Arsenal",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Crystal Palace",
            awayTeam: "Arsenal",
            date: "2019-08-10",
            time: "16:00:00",
            stadion: "Selhurst Park",
            image: "https://www.thesportsdb.com/images/media/event/thumb/4i0t7z1565391099.jpg",
            videoURL: "https://www.youtube.com/watch?v=DvEz6wC4r5w",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/tottenham_badge.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/arsenal_badge.png",
            statusString: "Not Started",
            homeScore: "8",
            awayScore: "2"
        ),
        Event(
            id: "602134",
            name: "Manchester City vs Arsenal",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Manchester City",
            awayTeam: "Tottenham",
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            image: "https://www.thesportsdb.com/images/media/event/thumb/uq2d001566644674.jpg",
            videoURL: "https://www.youtube.com/watch?v=EQe4D70MG3o",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/man_city_badge.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/arsenal_badge.png",
            statusString: "In Progress",
            homeScore: "5",
            awayScore: "5"
        ),
        Event(
            id: "602135",
            name: "Norwich vs Tottenham",
            sport: "Soccer",
            leagueName: "English Premier League",
            leagueImage: "https://www.thesportsdb.com/images/media/league/badge/dsnjpz1679951317.png",
            season: "2019-2020",
            homeTeam: "Manchester City",
            awayTeam: "Tottenham",
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            image: "https://www.thesportsdb.com/images/media/event/thumb/eoxk8v1565427742.jpg",
            videoURL: "https://www.youtube.com/watch?v=wthyUDmO1XU",
            homeTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/man_city_badge.png",
            awayTeamBadge: "https://www.thesportsdb.com/images/media/team/badge/arsenal_badge.png",
            statusString: "Not Started",
            homeScore: "0",
            awayScore: "4"
        )
    ]
    
    // MARK: - Mock Bets
    static let bets: [Bet] = [
        Bet(
            id: UUID(),
            event: events[0],
            userTip: .homeWin,
            odds: 1.80,
            winAmount: 18.0,
            timestamp: Date(),
            isWon: true
        ),
        Bet(
            id: UUID(),
            event: events[1],
            userTip: .draw,
            odds: 3.50,
            winAmount: nil,
            timestamp: Date(),
            isWon: false
        ),
        Bet(
            id: UUID(),
            event: events[2],
            userTip: .awayWin,
            odds: 4.20,
            winAmount: 42.0,
            timestamp: Date(),
            isWon: true
        )
    ]
    
    // MARK: - Mock BetSlips
    static let betSlips: [BetSlip] = [
        BetSlip(
            id: UUID(),
            userId: "user1",
            slipNumber: 1,
            bets: [bets[0]],
            createdAt: Date(),
            isWon: true,
            betAmount: 10.0,
            winAmount: 18.0
        ),
        BetSlip(
            id: UUID(),
            userId: "user2",
            slipNumber: 2,
            bets: [bets[1]],
            createdAt: Date(),
            isWon: false,
            betAmount: 10.0,
            winAmount: nil
        ),
        BetSlip(
            id: UUID(),
            userId: "user3",
            slipNumber: 3,
            bets: [bets[2]],
            createdAt: Date(),
            isWon: true,
            betAmount: 10.0,
            winAmount: 42.0
        ),
        BetSlip(
            id: UUID(),
            userId: "user4",
            slipNumber: 4,
            bets: [bets[0]],
            createdAt: Date(),
            isWon: true,
            betAmount: 10.0,
            winAmount: 18.0
        ),
        BetSlip(
            id: UUID(),
            userId: "user5",
            slipNumber: 5,
            bets: [bets[1]],
            createdAt: Date(),
            isWon: false,
            betAmount: 10.0,
            winAmount: nil
        ),
        BetSlip(
            id: UUID(),
            userId: "user6",
            slipNumber: 6,
            bets: [bets[2]],
            createdAt: Date(),
            isWon: true,
            betAmount: 10.0,
            winAmount: 42.0
        )
    ]
    
    // MARK: - Mock Profiles
    static let profiles: [Profile] = [
        Profile(
            id: "user1",
            name: "Max",
            email: "max@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 1500.0
        ),
        Profile(
            id: "user2",
            name: "Anna",
            email: "anna@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 800.0
        ),
        Profile(
            id: "user3",
            name: "Tom",
            email: "tom@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 2500.0
        ),
        Profile(
            id: "user4",
            name: "Max",
            email: "max@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 1500.0
        ),
        Profile(
            id: "user5",
            name: "Anna",
            email: "anna@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 800.0
        ),
        Profile(
            id: "user6",
            name: "Tom",
            email: "tom@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 2500.0
        ),
        Profile(
            id: "user7",
            name: "Max",
            email: "max@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 1500.0
        ),
        Profile(
            id: "user8",
            name: "Anna",
            email: "anna@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 800.0
        ),
        Profile(
            id: "user9",
            name: "Tom",
            email: "tom@example.com",
            birthday: Date(),
            startMoney: 1000.0,
            balance: 2500.0
        )
    ]
}
