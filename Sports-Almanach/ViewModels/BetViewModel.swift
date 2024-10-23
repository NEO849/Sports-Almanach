//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUICore
import FirebaseFirestore

class BetViewModel: ObservableObject {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Published var selectedBetEvent: Event?
    @Published var betAmount: Double = 0.0        // Wetteinsatz
    @Published var betOutcomeResult: BetOutcome?  // Ergebnis der Wette
    
    /// Führt die Wette aus
    func placeBet(on event: Event, outcome: BetOutcome, betAmount: Double) {
        
        // Wetteinsatz größer als Kontostand -> Fehler
        guard betAmount <= userViewModel.balance else {
            print("Fehler: Nicht genügend Guthaben.")
            return
        }
        
        // Berechnet die Quoten
        let odds = OddsCalculator.calculateOdds(for: event)
        
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
        
        // Aktualisiert den Kontostand
        let newBalance = userViewModel.balance - betAmount + winAmount
        userViewModel.balance = newBalance
        
        // In Firestore aktualisieren (über UserViewModel)
           userViewModel.updateBalance(newBalance: newBalance)
        
        // Wette in Firestore speichern
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        
        let dataB = Firestore.firestore()
        let betData: [String: Any] = [
            "userId": userId,
            "eventId": event.id,
            "betAmount": betAmount,
            "outcome": outcome.rawValue, // Speichern des Enums als String
            "winAmount": winAmount,
            "timestamp": Timestamp() // Aktueller Zeitstempel
        ]
        
        // Speichern in der "Bets"-Collection
        dataB.collection("Bets").addDocument(data: betData) { error in
            if let error = error {
                print("Fehler beim Speichern der Wette: \(error)")
            } else {
                print("Wette erfolgreich gespeichert.")
            }
        }
        
        // Neuen Kontostand in Firestore aktualisieren
        let profileData: [String: Any] = ["balance": newBalance]
        dataB.collection("Profile").document(userId).updateData(profileData) { error in
            if let error = error {
                print("Fehler beim Aktualisieren des Kontostands: \(error)")
            } else {
                print("Kontostand erfolgreich aktualisiert.")
            }
        }
        
        // Event und Ergebnis der Wette speichern
        selectedBetEvent = event
        betOutcomeResult = outcome
    }
    
    /// Kontostand zurückzusetzen
    func resetBalance() {
        userViewModel.balance = userViewModel.startMoney
        print("Kontostand wurde zurückgesetzt auf: \(userViewModel.startMoney)")    }
}
