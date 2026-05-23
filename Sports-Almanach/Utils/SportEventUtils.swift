//
//  SportEventUtils.swift
//  Sports-Almanach
//
//  Thin façade over OddsCalculator + date formatting. The legacy file held
//  the odds heuristic; that lives in Domain/Bet/OddsCalculator now so it can
//  be unit-tested without the rest of the app.
//

import Foundation

public enum SportEventUtils {

    /// Returns the legacy (homeWin, draw, awayWin) tuple driven by OddsCalculator.
    public static func calculateOdds(for event: Event) -> (homeWinOdds: Decimal, drawOdds: Decimal, awayWinOdds: Decimal) {
        let bundle = OddsCalculator.odds(homeScore: event.homeScore, awayScore: event.awayScore)
        return (bundle.homeWin, bundle.draw, bundle.awayWin)
    }

    // MARK: - Date / time

    private static let isoDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    private static let isoTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    private static let displayDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    private static let displayTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()

    public static func formattedDate(for event: Event) -> String {
        guard let dateObj = isoDateFormatter.date(from: event.date) else { return event.date }
        return displayDateFormatter.string(from: dateObj)
    }

    public static func formattedTime(for event: Event) -> String {
        guard let timeObj = isoTimeFormatter.date(from: event.time) else { return event.time }
        return displayTimeFormatter.string(from: timeObj)
    }
}
