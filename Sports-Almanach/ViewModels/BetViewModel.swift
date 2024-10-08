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
    @Published var user: User
    @Published var selectedEvent: Event?
    @Published var betAmount: Double = 0.0        // Wetteinsatz
    @Published var betOutcomeResult: BetOutcome?  // Status-ergebnis der Wette
    
    init(user: User) {
        self.user = user
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
        
        // Aktualisiert den Kontostand nach der Wette
        let newBalance = userViewModel.balance + winAmount
        userViewModel.balance = newBalance
        
    }
    
    /// Kontostand zurückzusetzen
    func resetBalance() {
        userViewModel.balance = user.startMoney
        print("Kontostand wurde zurückgesetzt auf: \(user.startMoney)")    }
}
