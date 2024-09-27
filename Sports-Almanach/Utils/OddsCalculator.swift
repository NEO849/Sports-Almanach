//
//  OddsCalculator.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.09.24.
//

import Foundation

/// Berechnet Quoten für Heimsieg, Unentschieden und Auswärtssieg basierend auf den Spielständen.
struct OddsCalculator {
    
    static func calculateOdds(homeScore: Int, awayScore: Int) -> (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double) {
        
        // Gesamte Tore berechnen
        let totalGoals = homeScore + awayScore
        
        // Heimsieg
        let homeWinOdds = totalGoals > 0 ? // Ob mindestens ein Tor gefallen ist
        max(1.2, Double(awayScore + 1) / Double(homeScore + 1)) : // Max das die Quote min 1.2
        2.0 // Standardquote für Heimsieg, wenn keine Tore
        
        // Auswärtssieg
        let awayWinOdds = totalGoals > 0 ? // Ob mindestens ein Tor gefallen ist
        max(1.2, Double(homeScore + 1) / Double(awayScore + 1)) :
        2.5 // Standardquote für Auswärtssieg, wenn keine Tore
        
        // Unentschieden
        let drawOdds = abs(homeScore - awayScore) <= 1 ? // Überprüfen des Torunterschieds
        3.0 :  // Geringer Torunterschied (maximal 1 Tor) -> niedrigere Quote für Unentschieden
        5.0    // Größerer Torunterschied -> höhere Quote für Unentschieden
        
        // Ein Tupel zurückgeben
        return (homeWinOdds: homeWinOdds, drawOdds: drawOdds, awayWinOdds: awayWinOdds)
    }
}
