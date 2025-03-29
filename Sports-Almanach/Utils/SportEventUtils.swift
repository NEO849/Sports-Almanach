//
//  SportEventUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.09.24.
//

import Foundation

/// Zentrale Utility-Klasse für alle Event-bezogenen Hilfsfunktionen
/// Beinhaltet:
/// - Quotenberechnung
/// - Datums- und Zeitformatierung
/// - Basis-Berechnungen für das Wettsystem
struct SportEventUtils {
    // MARK: - Konstanten für Basisquoten
    private static let minimumOdds: Double = 1.2
    private static let baseHomeOdds: Double = 2.0
    private static let baseAwayOdds: Double = 2.5
    private static let baseDrawOdds: Double = 3.0
    
    // MARK: - Quotenberechnung
    /// Berechnet die Quoten für ein Event basierend auf:
    /// - Aktuellen Torständen
    /// - Verhältnis der Tore
    /// - Minimalen Quotenvorgaben
    /// Returns: Tuple mit Quoten für (Heimsieg, Unentschieden, Auswärtssieg)
    static func calculateOdds(for event: Event) -> (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double) {
        let homeScore = Int(event.homeScore ?? "") ?? 0
        let awayScore = Int(event.awayScore ?? "") ?? 0
        let totalGoals = homeScore + awayScore
        
        // Wenn noch keine Tore gefallen sind, Standard-Quoten verwenden
        if totalGoals == 0 {
            return (baseHomeOdds, baseDrawOdds, baseAwayOdds)
        }
        
        // Dynamische Quotenberechnung basierend auf Torverhältnis
        let homeWinOdds = max(minimumOdds, Double(awayScore + 1) / Double(homeScore + 1))
        let awayWinOdds = max(minimumOdds, Double(homeScore + 1) / Double(awayScore + 1))
        // Unentschieden-Quote basierend auf Tordifferenz
        let drawOdds = abs(homeScore - awayScore) <= 1 ? 3.0 : 5.0
        
        return (homeWinOdds, drawOdds, awayWinOdds)
    }
    
    // MARK: - Datums- und Zeitformatierung
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    /// Konvertiert das API-Datumsformat in ein lesbares Format
    /// - Parameter event: Das Event mit dem zu formatierenden Datum
    /// - Returns: Formatiertes Datum (z.B. "15. März 2024")
    static func formattedDate(for event: Event) -> String {
        if let dateObj = dateFormatter.date(from: event.date) {
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: dateObj)
        }
        return event.date
    }
    
    /// Konvertiert das API-Zeitformat in ein lesbares Format
    /// - Parameter event: Das Event mit der zu formatierenden Zeit
    /// - Returns: Formatierte Zeit (z.B. "19:30")
    static func formattedTime(for event: Event) -> String {
        if let timeObj = timeFormatter.date(from: event.time) {
            timeFormatter.timeStyle = .short
            return timeFormatter.string(from: timeObj)
        }
        return event.time
    }
}
