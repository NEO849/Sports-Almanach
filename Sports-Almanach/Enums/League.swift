//
//  League.swift
//  Sports-Almanach
//
//  The league enum gains a `sportsDBLeagueID` so EventRepository can finally
//  use the user's selection. The legacy code hard-coded id=4328 and silently
//  ignored which league was chosen.
//

import Foundation

public enum League: String, Identifiable, CaseIterable, CustomStringConvertible, Codable, Sendable {
    case premierLeague = "English Premier League"
    case bundesliga    = "German Bundesliga"
    case laLiga        = "Spanish La Liga"
    case serieA        = "Italian Serie A"
    case ligue1        = "French Ligue 1"

    public var id: String { rawValue }

    public var description: String { shortName }

    public var shortName: String {
        switch self {
        case .premierLeague: return "Premier L."
        case .bundesliga:    return "Bundesliga"
        case .laLiga:        return "La Liga"
        case .serieA:        return "Serie A"
        case .ligue1:        return "Ligue 1"
        }
    }

    /// IDs taken from https://www.thesportsdb.com/api/v1/json/3/search_all_leagues.php?s=Soccer
    public var sportsDBLeagueID: String {
        switch self {
        case .premierLeague: return "4328"
        case .bundesliga:    return "4331"
        case .laLiga:        return "4335"
        case .serieA:        return "4332"
        case .ligue1:        return "4334"
        }
    }

    public static var `default`: League { .premierLeague }
}
