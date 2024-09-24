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
        let homeWinOdds = totalGoals > 0 ?
        max(1.2, Double(awayScore + 1) / Double(homeScore + 1)) :
        2.0
        
        // Auswärtssieg
        let awayWinOdds = totalGoals > 0 ?
        max(1.2, Double(homeScore + 1) / Double(awayScore + 1)) :
        2.5
        
        // UnentschiedenAuswärtssieg
        let drawOdds = abs(homeScore - awayScore) <= 1 ?
        3.0 :  // Geringer Torunterschied -> niedrigere Quote für Unentschieden
        5.0    // Größerer Torunterschied -> höhere Quote für Unentschieden
        
        
        // Ein Tupel mit den Wettquoten.
        return (homeWinOdds: homeWinOdds, drawOdds: drawOdds, awayWinOdds: awayWinOdds)
    }
}
