//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class BetViewModel: ObservableObject {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Published var selectedBetEvent: Event?
    @Published var betAmount: Double = 0.0 {
        didSet {
            potentialWinAmount = calculatePossibleWin()
        }
    }
    @Published var betOutcomeResult: BetOutcome?
    @Published var totalOdds: Double = 0.0
    @Published var potentialWinAmount: Double = 0.0
    @Published var bets: [Bet] = []
    
    // MARK: - Hilfsfunktionen
    
    /// Bestimmt den Spielausgang basierend auf den Toren
    func theWinnerIs(homeGoals: Int, awayGoals: Int) -> BetOutcome {
        if homeGoals > awayGoals {
            return .homeWin
        } else if homeGoals < awayGoals {
            return .awayWin
        } else {
            return .draw
        }
    }
    
    /// Aktualisiert die Gesamtquote aller Wetten
    func updateTotalOdds() {
        if bets.isEmpty {
            totalOdds = 0.0
            betAmount = 0.0
        } else {
            totalOdds = bets.reduce(1) { result, bet in
                result * bet.odds
            }
        }
        potentialWinAmount = calculatePossibleWin()
    }
    
    /// Möglicher Gewinn berechnen
    func calculatePossibleWin() -> Double {
        return betAmount * totalOdds
    }
    
    /// Kontostand zurücksetzen
    func resetBalance() {
        userViewModel.resetBalance()
    }
    
    /// Überprüft ob Wette bereits existiert
    func isBetAlreadyExists(for event: Event) -> Bool {
        return bets.contains(where: { $0.event.id == event.id })
    }
    
    // Property für Wettnummerierung
     private var currentBetNumber = UserDefaults.standard.integer(forKey: "currentBetNumber") {
         didSet {
             UserDefaults.standard.set(currentBetNumber, forKey: "currentBetNumber")
         }
     }
     
     // MARK: - Public Methods für Wettnummerierung
     /// Generiert die nächste verfügbare Wettnummer
     func nextBetNumber() -> Int {
         currentBetNumber += 1
         return currentBetNumber
     }
    
    /// Wette platzieren mit automatischer Nummerierung
    func placeBet(on event: Event, outcome: BetOutcome, betAmount: Double) {
        // Guthaben-Check
        guard betAmount <= userViewModel.userState.balance else {
            print("Fehler: Nicht genügend Guthaben.")
            return
        }
        
        // Quoten-Berechnung
        let odds = OddsCalculator.calculateOdds(for: event)
        var winAmount: Double = 0.0
        var selectedOdds: Double = 0.0
        
        // Quote basierend auf Outcome auswählen
        switch outcome {
        case .homeWin:
            selectedOdds = odds.homeWinOdds
            winAmount = betAmount * selectedOdds
        case .draw:
            selectedOdds = odds.drawOdds
            winAmount = betAmount * selectedOdds
        case .awayWin:
            selectedOdds = odds.awayWinOdds
            winAmount = betAmount * selectedOdds
        }
        
        // Neue Wette mit fortlaufender Nummer erstellen
        let betNumber = nextBetNumber()
        let newBet = Bet(
            event: event,
            outcome: outcome,
            odds: selectedOdds,
            amount: betAmount,
            winAmount: winAmount,
            betSlipNumber: betNumber
        )
        
        // Wette zur Liste hinzufügen
        bets.append(newBet)
        
        // Kontostand aktualisieren
        let newBalance = userViewModel.userState.balance - betAmount
        Task {
            userViewModel.updateBalance(newBalanceAfterBet: newBalance)
        }
        
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
            "outcome": outcome.rawValue,
            "winAmount": winAmount,
            "betNumber": betNumber,
            "timestamp": Timestamp()
        ]
        
        // In Firestore speichern
        dataB.collection("Bets").addDocument(data: betData) { error in
            if let error = error {
                print("Fehler beim Speichern der Wette: \(error)")
            } else {
                print("Wette erfolgreich gespeichert.")
            }
        }
        
        // UI State aktualisieren
        selectedBetEvent = event
        betOutcomeResult = outcome
        updateTotalOdds()
    }
}
