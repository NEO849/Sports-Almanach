//
//  BettingService.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 13.03.25
//

import Foundation

/// - Berechnung von Quoten und Gewinnen
/// - Verarbeitung und Auswertung von Wettscheinen
/// - Kommunikation mit dem Repository für Firestore-Operationen
class BettingService {
    private let repository: BetRepository
    
    init(repository: BetRepository = BetRepository()) {
        self.repository = repository
    }
    
    /// Berechnet die Gesamtquote für mehrere Wetten (Kombiwette)
    func calculateTotalOdds(_ bets: [Bet]) -> Double {
        bets.reduce(1.0) { $0 * $1.odds }
    }
    
    /// Berechnet den potenziellen Gewinn basierend auf Einsatz und Quote
    ///   - stake: Wetteinsatz
    ///   - odds: Quote (Einzel- oder Gesamtquote)
    func calculatePotentialWin(stake: Double, odds: Double) -> Double {
        let result = stake * odds
        return result.rounded(to: 2)
    }
    
    /// Verarbeitet einen kompletten Wettschein
    /// - Speichert den Wettschein in Firestore
    /// - Wertet die Wetten aus und berechnet den Gewinn
    /// - Returns: Tuple mit (Erfolgreich gespeichert, Gewinnbetrag falls gewonnen)
    func processBet(_ betSlip: BetSlip, userId: String, events: [Event]) async throws -> (saved: Bool, winAmount: Double?) {
        // Wettschein erst in Firestore speichern, Gesamtquote und möglichen Gewinn berechnen; Wettschein auswerten
        let saved = try await repository.saveBetSlip(betSlip, userId: userId)
        let totalOdds = calculateTotalOdds(betSlip.bets)
        let potentialWin = calculatePotentialWin(stake: betSlip.betAmount, odds: totalOdds)
        let (isWon, _) = evaluateBetSlip(betSlip, events: events)
        return (saved, isWon ? potentialWin : nil)
    }
    
    /// Wertet einen kompletten Wettschein aus
    /// Prüft jede einzelne Wette und aktualisiert den Gewinnstatus
    private func evaluateBetSlip(_ betSlip: BetSlip, events: [Event]) -> (isWon: Bool, totalWinAmount: Double) {
        var allBetsWon = true
        let eventDict = Dictionary(uniqueKeysWithValues: events.map { ($0.id, $0) })
        
        // Einzelwetten auswerten und Status in Firestore aktualisieren
        for bet in betSlip.bets {
            guard let event = eventDict[bet.event.id],
                  let eventResult = getEventResult(from: event) else {
                print("❌ Event oder Ergebnis nicht verfügbar für Event ID: \(bet.event.id)")
                return (false, 0.0)
            }
            
            let betWon = bet.userTip.rawValue == eventResult.rawValue
            allBetsWon = allBetsWon && betWon
            
            // Einzelwette Gewinnbetrag berechnen
            let singleBetWin = betWon ? calculatePotentialWin(stake: betSlip.betAmount / Double(betSlip.bets.count), odds: bet.odds) : nil
            
            // Wett-Status in Firestore aktualisieren
            Task {
                try? await repository.updateBetStatus(
                    betSlipId: betSlip.id.uuidString,
                    betId: bet.id.uuidString,
                    isWon: betWon,
                    winAmount: singleBetWin
                )
            }
        }
        
        // Gesamtgewinn berechnen wenn alle Wetten gewonnen wurden
        let totalOdds = calculateTotalOdds(betSlip.bets)
        let winAmount = calculatePotentialWin(stake: betSlip.betAmount, odds: totalOdds)
        
        // Gesamtstatus des Wettscheins aktualisieren
        Task {
            try? await repository.updateBetSlipStatus(
                betSlipId: betSlip.id,
                isWon: allBetsWon,
                winAmount: allBetsWon ? winAmount : nil
            )
        }
        return (allBetsWon, allBetsWon ? winAmount : 0.0)
    }
    
    /// Lädt die Historie der Wettscheine eines Benutzers
    func loadBetSlipHistory(userId: String) async throws -> [BetSlip] {
        try await repository.loadBetSlips(userId: userId)
    }
    
    /// Ermittelt das Ergebnis eines Events (1,0,2)
    private func getEventResult(from event: Event) -> EventResult? {
        guard let homeScore = Int(event.homeScore ?? ""),
              let awayScore = Int(event.awayScore ?? "") else {
            return nil
        }
        
        if homeScore > awayScore { return .homeWin }    // 1
        if homeScore < awayScore { return .awayWin }    // 2
        return .draw                                    // 0
    }
}

/// Rundungsoperation
private extension Double {
    func rounded(to places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
