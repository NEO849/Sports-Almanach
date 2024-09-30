//
//  MockEvents.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

/// Struktur, die Mockdaten für Sportevents bereitstellt
struct MockEvents {
    
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
            homeScore: 4,
            awayScore: 1,
            date: "2019-08-09",
            time: "19:00:00",
            stadion: "Anfield",
            image: "https://www.thesportsdb.com/images/media/event/thumb/mv7oni1565190477.jpg",
            videoURL: "https://www.youtube.com/watch?v=5WWOpHQ1yJo",
            status: .matchFinished
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
            homeScore: 2,
            awayScore: 2,
            date: "2019-08-10",
            time: "16:00:00",
            stadion: "Selhurst Park",
            image: "https://www.thesportsdb.com/images/media/event/thumb/cgbjmr1565361856.jpg",
            videoURL: "https://www.youtube.com/watch?v=VuEb0SzUNaI",
            status: .inProgress
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
            homeScore: 1,
            awayScore: 2,
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            image: "https://www.thesportsdb.com/images/media/event/thumb/5rncnc1566644537.jpg",
            videoURL: "https://www.youtube.com/watch?v=efgh5678"
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
            homeScore: 0,
            awayScore: 0,
            date: "2019-08-09",
            time: "19:00:00",
            stadion: "Anfield",
            image: "https://www.thesportsdb.com/images/media/event/thumb/ibh8sg1565615267.jpg",
            videoURL: "https://www.youtube.com/watch?v=WzGN6uWqwQ4"
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
            homeScore: 8,
            awayScore: 2,
            date: "2019-08-10",
            time: "16:00:00",
            stadion: "Selhurst Park",
            image: "https://www.thesportsdb.com/images/media/event/thumb/4i0t7z1565391099.jpg",
            videoURL: "https://www.youtube.com/watch?v=DvEz6wC4r5w"
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
            homeScore: 5,
            awayScore: 5,
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            image: "https://www.thesportsdb.com/images/media/event/thumb/uq2d001566644674.jpg",
            videoURL: "https://www.youtube.com/watch?v=EQe4D70MG3o"
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
            homeScore: 0,
            awayScore: 4,
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            image: "https://www.thesportsdb.com/images/media/event/thumb/eoxk8v1565427742.jpg",
            videoURL: "https://www.youtube.com/watch?v=wthyUDmO1XU"
        )
    ]
}
