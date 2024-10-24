//
//  Event.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

/// Modell für ein Sportevent, basierend auf der API-Antwort
struct Event: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let sport: String
    let leagueName: String
    let leagueImage: String
    let season: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: String?
    let awayScore: String?
    let date: String
    let time: String
    let stadion: String
    let image: String
    let videoURL: String?
    let homeTeamBadge: String?
    let awayTeamBadge: String?
    let statusString: String
    
    /// Enum zur Zuordnung der JSON-Schlüssel zu den Modell-Attributen
    enum CodingKeys: String, CodingKey {
        case id = "idEvent"
        case name = "strEvent"
        case sport = "strSport"
        case leagueName = "strLeague"
        case leagueImage = "strLeagueBadge"
        case season = "strSeason"
        case homeTeam = "strHomeTeam"
        case awayTeam = "strAwayTeam"
        case homeScore = "intHomeScore"
        case awayScore = "intAwayScore"
        case date = "dateEvent"
        case time = "strTime"
        case stadion = "strVenue"
        case image = "strThumb"
        case videoURL = "strVideo"
        case homeTeamBadge = "strHomeTeamBadge"
        case awayTeamBadge = "strAwayTeamBadge"
        case statusString = "strStatus"
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id // Vergleich basierend auf der ID
    }
}
