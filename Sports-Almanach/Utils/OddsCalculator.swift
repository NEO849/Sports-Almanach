//
//  OddsCalculator.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.09.24.
//

import Foundation

/// Berechnet Quoten für Heimsieg, Unentschieden und Auswärtssieg basierend auf den Spielständen.
struct OddsCalculator {
    
    static func calculateOdds(for event: Event) -> (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double) {
        
        // Konvertierung der Scores von String zu Int
        let homeScoreInt = Int(event.homeScore ?? "") ?? 0
        let awayScoreInt = Int(event.awayScore ?? "") ?? 0
        
        return (
            homeWinOdds: calculateHomeWinOdds(homeScore: homeScoreInt, awayScore: awayScoreInt),
            drawOdds: calculateDrawOdds(homeScore: homeScoreInt, awayScore: awayScoreInt),
            awayWinOdds: calculateAwayWinOdds(homeScore: homeScoreInt, awayScore: awayScoreInt))
    }
    
    // Heimsieg Quote
    private static func calculateHomeWinOdds(homeScore: Int, awayScore: Int) -> Double {
        let totalGoals = homeScore + awayScore
        // Wenn größer als 0 dann wird der "Ausdruck" ausgewertet, sonst keine Tore und 2.0 zurückgegeben
        return totalGoals > 0 ? max(1.2, Double(awayScore + 1) / Double(homeScore + 1)) : 2.0
    }
    
    private static func calculateDrawOdds(homeScore: Int, awayScore: Int) -> Double {
        return abs(homeScore - awayScore) <= 1 ? 3.0 : 5.0
    }
    
    private static func calculateAwayWinOdds(homeScore: Int, awayScore: Int) -> Double {
        let totalGoals = homeScore + awayScore
        return totalGoals > 0 ? max(1.2, Double(homeScore + 1) / Double(awayScore + 1)) : 2.5
    }
}
