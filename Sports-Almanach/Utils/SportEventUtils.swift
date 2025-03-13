//
//  SportEventUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.09.24.
//

import Foundation

/// Zentrale -Klasse für alle Wett-bezogenen Berechnungen
struct SportEventUtils {
    
    /// Ermittelt das tatsächliche Ergebnis eines Events
    static func determineResult(from event: Event) -> EventResult? {
        guard let homeScore = Int(event.homeScore ?? ""),
              let awayScore = Int(event.awayScore ?? "") else {
            return nil
        }
        
        if homeScore > awayScore { return .homeWin }    // 1
        if homeScore < awayScore { return .awayWin }    // 2
        return .draw                                    // 0
    }

    /// Vergleicht User-Tipp mit tatsächlichem Ergebnis
    static func isCorrectTip(_ userPick: UserTip, for event: Event) -> Bool {
        guard let result = determineResult(from: event) else { return false }
        return userPick.rawValue == result.rawValue  // Direkter Int-Vergleich (1,0,2)
    }
    
    /// Berechnet den möglichen Gewinn für eine Wette
    static func calculatePossibleWin(betAmount: Double, odds: Double) -> Double {
        return betAmount * odds
    }
    
    /// Berechnet den Gesamtgewinn für einen Wettschein
    static func calculateTotalWinAmount(bets: [Bet]) -> Double {
        bets.reduce(0) { $0 + ($1.winAmount ?? 0) }
    }
    
    /// Wertet einen kompletten Wettschein aus
    static func evaluateBetSlip(_ betSlip: BetSlip, events: [Event]) -> (isWon: Bool, totalWinAmount: Double) {
        var allBetsWon = true
        var totalWinAmount = 0.0
        
        for bet in betSlip.bets {
            guard let event = events.first(where: { $0.id == bet.event.id }) else { continue }
            guard let result = determineResult(from: event) else { continue }
            
            // Vergleiche User-Tipp mit Ergebnis
            if bet.userPick.rawValue == result.rawValue {
                totalWinAmount += calculatePossibleWin(betAmount: bet.betAmount, odds: bet.odds)
            } else {
                allBetsWon = false
                break
            }
        }
        
        return (allBetsWon, totalWinAmount)
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
