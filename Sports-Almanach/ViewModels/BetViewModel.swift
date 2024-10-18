//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUICore

class BetViewModel: ObservableObject {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Published var selectedBetEvent: Event?
    @Published var betAmount: Double = 0.0        // Wetteinsatz
    @Published var betOutcomeResult: BetOutcome?  // Ergebnis der Wette
    
    /// Führt die Wette aus
    func placeBet(on event: Event, outcome: BetOutcome, betAmount: Double) {
        // Speichert das Event, auf das gewettet wurde
        selectedBetEvent = event
        self.betAmount = betAmount
        
        // Konvertierung der Scores von String zu Int
        let homeScoreInt = Int(event.homeScore ?? "") ?? 0  // Falls die Umwandlung fehlschlägt
        let awayScoreInt = Int(event.awayScore ?? "") ?? 0
        
        // Berechnet die Quoten
        let odds = OddsCalculator.calculateOdds(homeScore: homeScoreInt, awayScore: awayScoreInt)
        
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
        
        // Aktualisiert den Kontostand nach der Wette
        let newBalance = userViewModel.balance + winAmount
        userViewModel.balance = newBalance
        
    }
    
//    /// Kontostand zurückzusetzen
//    func resetBalance() {
//        userViewModel.balance = user.startMoney
//        print("Kontostand wurde zurückgesetzt auf: \(user.startMoney)")    }
}
