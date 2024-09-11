//
//  MockEvents.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

/// Struktur, die Mockdaten für Sportevents bereitstellt
struct MockEvents {
    
    /// Mockdaten für Events
    static let events: [Event] = [
        Event(
            id: "1570706",
            name: "Crystal Palace vs Arsenal",
            homeTeam: "Crystal Palace",
            awayTeam: "Arsenal",
            date: "2022-08-05",
            time: "19:00",
            venue: "Selhurst Park",
            official: "Lothar Matthäus",
            status: .scheduled,
            homeTeamOdds: 2.5,  // Keine Quoten in der API-Antwort, daher hier Platzhalter
            drawOdds: 6.0,
            awayTeamOdds: 1.0,
            description: "The Premier is back! After a few eternal weeks without club football, the best league in the world is here. Crystal Palace and Arsenal are in charge of kicking off this new season. A high-level match between two Premier League classics!",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/ktydks1659896704.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/l65ygm1659893265.jpg"
        ),
        Event(
            id: "E002",
            name: "Premier League Spieltag 5",
            homeTeam: "Manchester United",
            awayTeam: "Liverpool FC",
            date: "2024-09-12",
            time: "20:45",
            venue: "Old Trafford",
            official: "Michael Oliver",
            status: .scheduled,
            homeTeamOdds: 2.2,
            drawOdds: 3.2,
            awayTeamOdds: 2.8,
            description: "A key match in the Premier League where Manchester United faces off against Liverpool FC. Fans are eagerly anticipating this classic rivalry.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/english-premier-league.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/english-premier-league.jpg"
        ),
        Event(
            id: "E003",
            name: "La Liga Clásico",
            homeTeam: "FC Barcelona",
            awayTeam: "Real Madrid",
            date: "2024-10-05",
            time: "21:00",
            venue: "Camp Nou",
            official: "Antonio Mateu Lahoz",
            status: .scheduled,
            homeTeamOdds: 2.0,
            drawOdds: 3.4,
            awayTeamOdds: 3.0,
            description: "The iconic La Liga clash between FC Barcelona and Real Madrid at the Camp Nou. A highly anticipated match for football fans worldwide.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/la-liga-classico.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/la-liga-classico.jpg"
        ),
        Event(
            id: "E004",
            name: "Serie A Derby",
            homeTeam: "AC Mailand",
            awayTeam: "Inter Mailand",
            date: "2024-11-15",
            time: "19:00",
            venue: "San Siro",
            official: "Daniele Orsato",
            status: .locked,
            homeTeamOdds: 2.5,
            drawOdds: 3.1,
            awayTeamOdds: 2.6,
            description: "The thrilling Serie A Derby between AC Milan and Inter Milan. A highly competitive match at the iconic San Siro stadium.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/serie-a-derby.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/serie-a-derby.jpg"
        ),
        Event(
            id: "E005",
            name: "Ligue 1 Klassiker",
            homeTeam: "Paris Saint-Germain",
            awayTeam: "Olympique Marseille",
            date: "2024-12-01",
            time: "20:00",
            venue: "Parc des Princes",
            official: "Clément Turpin",
            status: .scheduled,
            homeTeamOdds: 1.5,
            drawOdds: 4.0,
            awayTeamOdds: 5.5,
            description: "A major Ligue 1 clash between Paris Saint-Germain and Olympique Marseille at the Parc des Princes. A match with significant implications for the title race.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/ligue1-classic.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/ligue1-classic.jpg"
        ),
        Event(
            id: "E006",
            name: "Champions League Finale",
            homeTeam: "Manchester City",
            awayTeam: "FC Bayern München",
            date: "2025-05-25",
            time: "20:45",
            venue: "Wembley Stadium",
            official: "Björn Kuipers",
            status: .scheduled,
            homeTeamOdds: 1.9,
            drawOdds: 3.6,
            awayTeamOdds: 3.2,
            description: "The grand finale of the UEFA Champions League featuring Manchester City against FC Bayern Munich. A highlight of the European football season.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/champions-league-final.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/champions-league-final.jpg"
        ),
        Event(
            id: "E007",
            name: "Europa League Finale",
            homeTeam: "Arsenal FC",
            awayTeam: "AS Rom",
            date: "2025-05-18",
            time: "21:00",
            venue: "Olympiastadion Berlin",
            official: "Cüneyt Çakır",
            status: .cancelled,
            homeTeamOdds: 2.3,
            drawOdds: 3.3,
            awayTeamOdds: 2.9,
            description: "The Europa League final featuring Arsenal FC versus AS Roma. A crucial match for European glory.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/europa-league-final.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/europa-league-final.jpg"
        ),
        Event(
            id: "E008",
            name: "DFB-Pokal Finale",
            homeTeam: "RB Leipzig",
            awayTeam: "Eintracht Frankfurt",
            date: "2025-06-10",
            time: "20:00",
            venue: "Olympiastadion Berlin",
            official: "Deniz Aytekin",
            status: .scheduled,
            homeTeamOdds: 2.0,
            drawOdds: 3.5,
            awayTeamOdds: 3.1,
            description: "The final of the DFB-Pokal with RB Leipzig facing Eintracht Frankfurt. A thrilling conclusion to the German domestic cup competition.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/dfb-pokal-final.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/dfb-pokal-final.jpg"
        ),
        Event(
            id: "E009",
            name: "FA Cup Finale",
            homeTeam: "Chelsea FC",
            awayTeam: "Tottenham Hotspur",
            date: "2025-06-15",
            time: "18:00",
            venue: "Wembley Stadium",
            official: "Martin Atkinson",
            status: .locked,
            homeTeamOdds: 2.1,
            drawOdds: 3.2,
            awayTeamOdds: 3.0,
            description: "The FA Cup final between Chelsea FC and Tottenham Hotspur at Wembley Stadium. A historic match in English football.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/fa-cup-final.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/fa-cup-final.jpg"
        ),
        Event(
            id: "E010",
            name: "Supercopa de España",
            homeTeam: "Atlético Madrid",
            awayTeam: "FC Sevilla",
            date: "2025-08-20",
            time: "22:00",
            venue: "Estadio Santiago Bernabéu",
            official: "Carlos del Cerro Grande",
            status: .scheduled,
            homeTeamOdds: 1.9,
            drawOdds: 3.4,
            awayTeamOdds: 3.5,
            description: "The Supercopa de España featuring Atlético Madrid against FC Sevilla. A significant Spanish Super Cup match.",
            bannerURL: "https://www.thesportsdb.com/images/media/event/banner/supercopa-de-espana.jpg",
            squareURL: "https://www.thesportsdb.com/images/media/event/square/supercopa-de-espana.jpg"
        )
    ]
}
