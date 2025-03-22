//
//  BettingService.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 13.03.25
//

import Foundation

/// Service-Layer für die Wettverarbeitung und Auswertung
class BettingService {
    private let repository: BetRepository
    
    init(repository: BetRepository = BetRepository()) {
        self.repository = repository
    }
    
    /// Berechnet den Gesamteinsatz für einen Wettschein
    func calculateTotalStake(_ bets: [Bet]) -> Double {
        bets.reduce(0.0) { $0 + $1.betAmount }
    }
    
    /// Berechnet die Gesamtquote für einen Wettschein
    func calculateTotalOdds(_ bets: [Bet]) -> Double {
        bets.reduce(1.0) { $0 * $1.odds }
    }
    
    /// Berechnet den möglichen Gewinn
    func calculatePotentialWin(stake: Double, odds: Double) -> Double {
        let result = stake * odds
        return result.rounded(to: 2)
    }
    
    // MARK: - Verarbeitet einen kompletten Wetteinsatz
    func processBet(_ betSlip: BetSlip, userId: String, events: [Event]) async throws -> (saved: Bool, winAmount: Double?) {
        let saved = try await repository.saveBetSlip(betSlip, userId: userId)
        let totalStake = calculateTotalStake(betSlip.bets)
        let totalOdds = calculateTotalOdds(betSlip.bets)
        let potentialWin = calculatePotentialWin(stake: totalStake, odds: totalOdds)
        
        let (isWon, _) = evaluateBetSlip(betSlip, events: events)
        return (saved, isWon ? potentialWin : nil)
    }
    
    // MARK: - Wertet einen kompletten Wettschein aus
    private func evaluateBetSlip(_ betSlip: BetSlip, events: [Event]) -> (isWon: Bool, totalWinAmount: Double) {
        let eventDict = Dictionary(uniqueKeysWithValues: events.map { ($0.id, $0) })
        
        // Prüft jede Wette im Schein
        for bet in betSlip.bets {
            guard let event = eventDict[bet.event.id],
                  let eventResult = getEventResult(from: event) else {
                print("❌ Event oder Ergebnis nicht verfügbar")
                return (false, 0.0)
            }
            if bet.userTip.rawValue != eventResult.rawValue {
                print("❌ Wette verloren - Tipp: \(bet.userTip.rawValue), Ergebnis: \(eventResult.rawValue)")
                return (false, 0.0)
            }
            print("✅ Wette gewonnen - Tipp: \(bet.userTip.titleGerman)")
        }
        
        // Gewinnberechnung direkt hier
        let totalStake = calculateTotalStake(betSlip.bets)
        let totalOdds = calculateTotalOdds(betSlip.bets)
        let winAmount = calculatePotentialWin(stake: totalStake, odds: totalOdds)
        
        return (true, winAmount)
    }
    
    /// Lädt historische Wettscheine
    func loadBetSlipHistory(userId: String) async throws -> [BetSlip] {
        try await repository.loadBetSlips(userId: userId)
    }
    
    /// Ermittelt das Ergebnis eines Events (1,0,2)
    private func getEventResult(from event: Event) -> EventResult? {
        guard let homeScore = Int(event.homeScore ?? ""),
              let awayScore = Int(event.awayScore ?? "") else {
            return nil
        }
        // Bestimmt das Ergebnis basierend auf den Toren
        if homeScore > awayScore { return .homeWin }    // 1
        if homeScore < awayScore { return .awayWin }    // 2
        return .draw                                    // 0
    }
}

// MARK: - Double Extension für interne Berechnungen
/// Die Extension ist nur innerhalb dieser Datei verfügbar
private extension Double {
    func rounded(to places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
