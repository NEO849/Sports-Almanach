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
            season: "2019-2020",
            homeTeam: "Liverpool",
            awayTeam: "Norwich",
            homeScore: 4,
            awayScore: 1,
            date: "2019-08-09",
            time: "19:00:00",
            stadion: "Anfield",
            thumbURL: "https://www.thesportsdb.com/images/media/event/thumb/mv7oni1565190477.jpg",
            videoURL: "https://www.youtube.com/watch?v=5WWOpHQ1yJo",
            status: .normal,
            homeWinOdds: 1.4,
            drawOdds: 4.0,
            awayWinOdds: 6.5
        ),
        Event(
            id: "602130",
            name: "Crystal Palace vs Arsenal",
            sport: "Soccer",
            leagueName: "English Premier League",
            season: "2019-2020",
            homeTeam: "Crystal Palace",
            awayTeam: "Arsenal",
            homeScore: 2,
            awayScore: 2,
            date: "2019-08-10",
            time: "16:00:00",
            stadion: "Selhurst Park",
            thumbURL: "https://www.thesportsdb.com/images/media/event/thumb/xyz123.jpg",
            videoURL: "https://www.youtube.com/watch?v=abcd1234",
            status: .scheduled,
            homeWinOdds: 3.0,
            drawOdds: 3.5,
            awayWinOdds: 2.5
        ),
        Event(
            id: "602131",
            name: "Manchester City vs Tottenham",
            sport: "Soccer",
            leagueName: "English Premier League",
            season: "2019-2020",
            homeTeam: "Manchester City",
            awayTeam: "Tottenham",
            homeScore: 1,
            awayScore: 2,
            date: "2019-08-11",
            time: "17:00:00",
            stadion: "Etihad Stadium",
            thumbURL: "https://www.thesportsdb.com/images/media/event/thumb/abc456.jpg",
            videoURL: "https://www.youtube.com/watch?v=efgh5678",
            status: .postponed,
            homeWinOdds: 2.0,
            drawOdds: 3.0,
            awayWinOdds: 4.0
        ),
        Event(
            id: "602132",
            name: "Chelsea vs Manchester United",
            sport: "Soccer",
            leagueName: "English Premier League",
            season: "2019-2020",
            homeTeam: "Chelsea",
            awayTeam: "Manchester United",
            homeScore: 3,
            awayScore: 3,
            date: "2019-08-12",
            time: "20:00:00",
            stadion: "Stamford Bridge",
            thumbURL: "https://www.thesportsdb.com/images/media/event/thumb/def789.jpg",
            videoURL: "https://www.youtube.com/watch?v=ijkl9012",
            status: .cancelled,
            homeWinOdds: 2.8,
            drawOdds: 3.2,
            awayWinOdds: 3.5
        )
    ]
}
