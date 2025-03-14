//
//  BettingService.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 13.03.25.
//

import Foundation

/// Service-Layer für die Wettverarbeitung und Auswertung
class BettingService {
    private let repository: BetRepository
    
    init(repository: BetRepository = BetRepository()) {
        self.repository = repository
    }
    
    // MARK: - Verarbeitet einen kompletten Wetteinsatz, Tuple mit Speicherstatus und optionalem Gewinn
    func processBet(_ betSlip: BetSlip, userId: String, events: [Event]) async throws -> (saved: Bool, winAmount: Double?) {
        let saved = try await repository.saveBetSlip(betSlip, userId: userId)
        let (isWon, winAmount) = evaluateBetSlip(betSlip, events: events)
        return (saved, isWon ? winAmount : nil)
    }
    
    /// Lädt historische Wettscheine
    func loadBetHistory(userId: String) async throws -> [BetSlip] {
        try await repository.loadBetSlips(userId: userId)
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
            // UserTip mit EventResult anhand der rawValues vergleichen
            if bet.userTip.rawValue != eventResult.rawValue {
                print("❌ Wette verloren - Tipp: \(bet.userTip.rawValue), Ergebnis: \(eventResult.rawValue)")
                return (false, 0.0)
            }
            print("✅ Wette gewonnen - Tipp: \(bet.userTip.titleGerman)")
        }
        // Alle Wetten waren richtig - Gewinn berechnen
        return (true, betSlip.potentialWinAmount)
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
