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
        
        // Berechnung für Heimsieg
        let homeWinOdds = totalGoals > 0 ?
            max(1.2, Double(awayScore + 1) / Double(homeScore + 1)) :  // Maximiert die Quote auf 1.2, um eine Basisquote sicherzustellen
            2.0  // Wenn keine Tore gefallen sind, Rückgabe einer Standardquote von 2.0
        
        // Berechnung für Auswärtssieg
        let awayWinOdds = totalGoals > 0 ?
            max(1.2, Double(homeScore + 1) / Double(awayScore + 1)) : 2.5
        
        // Wenn der Unterschied zwischen den Toren 1 oder weniger beträgt, ist die Quote für ein Unentschieden geringer
        let drawOdds = abs(homeScore - awayScore) <= 1 ?
            3.0 :  // Höhere Quote bei geringem
            5.0    // Niedrigere Quote bei größerem Punktunterschied
        
        // Ein Tupel mit den Wettquoten.
        return (homeWinOdds: homeWinOdds, drawOdds: drawOdds, awayWinOdds: awayWinOdds)
    }
}
