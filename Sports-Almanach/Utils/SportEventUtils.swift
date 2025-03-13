//
//  SportEventUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.09.24.
//

import Foundation

/// Zentrale -Klasse für alle Wett-bezogenen Berechnungen
struct SportEventUtils {
    
    /// Ermittelt Spielergebnis als Int-Werte (1,0,2)
    static func determineResult(from event: Event) -> EventResult? {
        guard let homeScore = Int(event.homeScore ?? ""),
              let awayScore = Int(event.awayScore ?? "") else {
            return nil
        }
        
        if homeScore > awayScore { return .homeWin }
        if homeScore < awayScore { return .awayWin }
        return .draw
    }
    
    /// Wertet einen kompletten Wettschein aus
    ///   - betSlip: Der zu prüfende Wettschein
    ///   - events: Liste aller Events zum Vergleich
    /// - Returns: Tuple mit (gewonnen/verloren, Gesamtgewinn)
    static func evaluateBetSlip(_ betSlip: BetSlip, events: [Event]) -> (isWon: Bool, totalWinAmount: Double) {
        // Dictionary für schnelleren Event-Lookup
        let eventDict = Dictionary(uniqueKeysWithValues: events.map { ($0.id, $0) })
        
        // Prüfe alle Wetten im Schein
        for bet in betSlip.bets {
            guard let event = eventDict[bet.event.id],
                  let result = determineResult(from: event) else {
                return (false, 0.0)
            }
            
            // Prüfe ob Tipp korrekt war
            if bet.userTip.rawValue != result.rawValue {
                return (false, 0.0)
            }
        }
        
        // Alle Wetten gewonnen - berechne Gesamtgewinn
        return (true, betSlip.potentialWinAmount)
    }
    
    /// Berechnet den möglichen Gewinn für eine Wette
    static func calculatePossibleWin(betAmount: Double, odds: Double) -> Double {
        betAmount * odds
    }
    // MARK: - Quoten Berechnung
    static func calculateOdds(for event: Event) -> (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double) {
        let homeScore = Int(event.homeScore ?? "") ?? 0
        let awayScore = Int(event.awayScore ?? "") ?? 0
        
        return (
            homeWinOdds: calculateHomeWinOdds(homeScore: homeScore, awayScore: awayScore),
            drawOdds: calculateDrawOdds(homeScore: homeScore, awayScore: awayScore),
            awayWinOdds: calculateAwayWinOdds(homeScore: homeScore, awayScore: awayScore)
        )
    }
    
    /// Berechnet den Gesamteinsatz eines Wettscheins
    static func calculateTotalStake(_ bets: [Bet]) -> Double {
        bets.reduce(0) { $0 + $1.betAmount }
    }
    
    /// Die Gesamtquote eines Wettscheins
    static func calculateTotalOdds(_ bets: [Bet]) -> Double {
        bets.reduce(1.0) { $0 * $1.odds }
    }
    
    /// Den möglichen Gesamtgewinn
    static func calculatePotentialWin(stake: Double, odds: Double) -> Double {
        stake * odds
    }
    
    
    // MARK: - Private Helper
    private static func calculateHomeWinOdds(homeScore: Int, awayScore: Int) -> Double {
        let totalGoals = homeScore + awayScore
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
