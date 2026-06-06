//
//  Event.swift
//  Sports-Almanach
//
//  Domain Event model. Replaces Data/Models/Event.swift with two material
//  changes:
//
//  - Scores are stored as `Int?` rather than `String?`. The legacy code
//    repeatedly did `Int(event.homeScore ?? "")` at call sites, masking
//    bad-data cases. We parse once at the boundary (`init(from decoder:)`).
//  - A semantic `status` enum exposes the lifecycle (`scheduled`, `inProgress`,
//    `finished`, `postponed`, `cancelled`) instead of leaking the raw status
//    string everywhere.
//

import Foundation

public struct Event: Identifiable, Codable, Hashable, Sendable {

    public let id: String
    public let name: String
    public let sport: String
    public let leagueName: String
    public let leagueImage: String?
    public let season: String
    public let homeTeam: String
    public let awayTeam: String
    public let homeScore: Int?
    public let awayScore: Int?
    public let kickoffISO: String     // raw "yyyy-MM-dd" + "HH:mm:ss" already concatenated
    public let date: String           // preserved for compatibility / direct display
    public let time: String
    public let stadium: String
    public let thumbnail: String?
    public let videoURL: String?
    public let homeTeamBadge: String?
    public let awayTeamBadge: String?
    public let status: EventStatus

    public init(id: String,
                name: String,
                sport: String,
                leagueName: String,
                leagueImage: String?,
                season: String,
                homeTeam: String,
                awayTeam: String,
                homeScore: Int? = nil,
                awayScore: Int? = nil,
                kickoffISO: String,
                date: String,
                time: String,
                stadium: String,
                thumbnail: String? = nil,
                videoURL: String? = nil,
                homeTeamBadge: String? = nil,
                awayTeamBadge: String? = nil,
                status: EventStatus = .scheduled) {
        self.id = id
        self.name = name
        self.sport = sport
        self.leagueName = leagueName
        self.leagueImage = leagueImage
        self.season = season
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.kickoffISO = kickoffISO
        self.date = date
        self.time = time
        self.stadium = stadium
        self.thumbnail = thumbnail
        self.videoURL = videoURL
        self.homeTeamBadge = homeTeamBadge
        self.awayTeamBadge = awayTeamBadge
        self.status = status
    }

    /// Convenience snapshot suitable for embedding inside a Bet.
    public var snapshot: EventSnapshot {
        EventSnapshot(
            eventID: id,
            name: name,
            leagueName: leagueName,
            sport: sport,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            kickoffISO: kickoffISO,
            homeScore: homeScore,
            awayScore: awayScore,
            isFinished: status == .finished
        )
    }

    // MARK: - Decoding
    // SportsDB returns scores as numeric strings ("2") or null. We coerce to
    // Int? in one place and stop the rest of the code from doing it.

    private enum CodingKeys: String, CodingKey {
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
        case kickoffISO = "strTimestamp"
        case date = "dateEvent"
        case time = "strTime"
        case stadium = "strVenue"
        case thumbnail = "strThumb"
        case videoURL = "strVideo"
        case homeTeamBadge = "strHomeTeamBadge"
        case awayTeamBadge = "strAwayTeamBadge"
        case statusRaw = "strStatus"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decode(String.self, forKey: .id)
        self.name = (try? c.decode(String.self, forKey: .name)) ?? ""
        self.sport = (try? c.decode(String.self, forKey: .sport)) ?? ""
        self.leagueName = (try? c.decode(String.self, forKey: .leagueName)) ?? ""
        self.leagueImage = try? c.decode(String.self, forKey: .leagueImage)
        self.season = (try? c.decode(String.self, forKey: .season)) ?? ""
        self.homeTeam = (try? c.decode(String.self, forKey: .homeTeam)) ?? ""
        self.awayTeam = (try? c.decode(String.self, forKey: .awayTeam)) ?? ""
        self.homeScore = Event.intOrNil(c, .homeScore)
        self.awayScore = Event.intOrNil(c, .awayScore)
        self.kickoffISO = (try? c.decode(String.self, forKey: .kickoffISO)) ?? ""
        self.date = (try? c.decode(String.self, forKey: .date)) ?? ""
        self.time = (try? c.decode(String.self, forKey: .time)) ?? ""
        self.stadium = (try? c.decode(String.self, forKey: .stadium)) ?? ""
        self.thumbnail = try? c.decode(String.self, forKey: .thumbnail)
        self.videoURL = try? c.decode(String.self, forKey: .videoURL)
        self.homeTeamBadge = try? c.decode(String.self, forKey: .homeTeamBadge)
        self.awayTeamBadge = try? c.decode(String.self, forKey: .awayTeamBadge)
        let statusString = (try? c.decode(String.self, forKey: .statusRaw)) ?? ""
        self.status = EventStatus(rawAPIValue: statusString)
    }

    /// SportsDB occasionally returns scores as ints, sometimes strings, sometimes null.
    /// Coerce all variants to `Int?` once.
    private static func intOrNil(_ c: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) -> Int? {
        if let i = try? c.decode(Int.self, forKey: key) { return i }
        if let s = try? c.decode(String.self, forKey: key), let i = Int(s) { return i }
        return nil
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(sport, forKey: .sport)
        try c.encode(leagueName, forKey: .leagueName)
        try c.encodeIfPresent(leagueImage, forKey: .leagueImage)
        try c.encode(season, forKey: .season)
        try c.encode(homeTeam, forKey: .homeTeam)
        try c.encode(awayTeam, forKey: .awayTeam)
        try c.encodeIfPresent(homeScore, forKey: .homeScore)
        try c.encodeIfPresent(awayScore, forKey: .awayScore)
        try c.encode(kickoffISO, forKey: .kickoffISO)
        try c.encode(date, forKey: .date)
        try c.encode(time, forKey: .time)
        try c.encode(stadium, forKey: .stadium)
        try c.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try c.encodeIfPresent(videoURL, forKey: .videoURL)
        try c.encodeIfPresent(homeTeamBadge, forKey: .homeTeamBadge)
        try c.encodeIfPresent(awayTeamBadge, forKey: .awayTeamBadge)
        try c.encode(status.apiValue, forKey: .statusRaw)
    }
}
