//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation

class BetViewModel: ObservableObject {
    
    @Published var user: User
    @Published var selectedEvent: Event?          // Ausgewähltes Event für die Wette
    @Published var betAmount: Double = 0.0        // Wetteinsatz
    @Published var betResultMessage: String?      // Nachricht nach der Wette
    @Published var newBalance: Double = 0.0       // Neuer Kontostand nach der Wette
    @Published var betOutcomeResult: BetOutcome?  // Status-ergebnis der Wette
    @Published var showBetResult: Bool = false

    init(user: User) {
        self.user = user
        self.newBalance = user.startMoney // Initialer Kontostand
    }

    /// Berechnet die Quoten für das ausgewählte Event und führt die Wette aus
    func placeBet(on event: Event, outcome: BetOutcome, betAmount: Double) {
        // Speichert das Event, auf das gewettet wurde
        selectedEvent = event
        self.betAmount = betAmount
        
        // Berechnet die Quoten
        let odds = OddsCalculator.calculateOdds(homeScore: event.homeScore, awayScore: event.awayScore)
        
        // Ergebnis basierend auf der Auswahl und den Quoten
        var winAmount: Double = 0.0
        switch outcome {
        case .homeWin:
            winAmount = betAmount * odds.homeWinOdds
        case .draw:
            winAmount = betAmount * odds.drawOdds
        case .awayWin:
            winAmount = betAmount * odds.awayWinOdds
        }
        
        // Bestimme das Ergebnis der Wette
        if winAmount > 0 {
            // Wette gewonnen
            betOutcomeResult = .homeWin
        } else if odds.drawOdds > 1.0 {
            // Unentschieden
            betOutcomeResult = .draw
        } else {
            // Wette verloren
            betOutcomeResult = .awayWin
        }
        
        // Aktualisiert den Kontostand
        newBalance = user.startMoney + winAmount
        
        // Ergebnisnachricht
        betResultMessage = "Dein Gewinn: \(String(format: "%.2f", winAmount))"
        
        // Wette beendet, zeigt das Ergebnis-Sheet an
        showBetResult = true
    }
}
