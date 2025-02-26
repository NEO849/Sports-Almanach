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
    
    /// Initialisierung aus Firestore-Daten
    init(id: String,
         name: String,
         sport: String,
         leagueName: String,
         leagueImage: String,
         season: String,
         homeTeam: String,
         awayTeam: String,
         date: String,
         time: String,
         stadion: String,
         image: String,
         videoURL: String?,
         homeTeamBadge: String?,
         awayTeamBadge: String?,
         statusString: String,
         homeScore: String? = nil,
         awayScore: String? = nil) {
        self.id = id
        self.name = name
        self.sport = sport
        self.leagueName = leagueName
        self.leagueImage = leagueImage
        self.season = season
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.date = date
        self.time = time
        self.stadion = stadion
        self.image = image
        self.videoURL = videoURL
        self.homeTeamBadge = homeTeamBadge
        self.awayTeamBadge = awayTeamBadge
        self.statusString = statusString
        self.homeScore = homeScore
        self.awayScore = awayScore
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id // Vergleich basierend auf der ID
    }
}
