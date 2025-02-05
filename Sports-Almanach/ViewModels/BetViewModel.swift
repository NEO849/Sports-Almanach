//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
class BetViewModel: ObservableObject {
    
    private var userViewModel: UserViewModel?
    private var eventViewModel: EventViewModel?
    
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
    
    // MARK: - Properties für Statistik
    @Published var allBets: [Bet] = []
    @Published var currentBetNumber: Int = UserDefaults.standard.integer(forKey: "currentBetNumber") {
        didSet {
            UserDefaults.standard.set(currentBetNumber, forKey: "currentBetNumber")
        }
    }
    
    init() {
        // Keine direkte Initialisierung der ViewModels
        // Diese werden später über setViewModels gesetzt
    }
    
    // Setter für ViewModels - wird von außen aufgerufen
    func setViewModels(user: UserViewModel, event: EventViewModel) {
        self.userViewModel = user
        self.eventViewModel = event
    }
    
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
    
    /// Kontostand asynchron zurücksetzen
    func resetBalance() {
        userViewModel?.resetBalance()
    }
    
    /// Überprüft ob Wette bereits existiert
    func isBetAlreadyExists(for event: Event) -> Bool {
        return bets.contains(where: { $0.event.id == event.id })
    }
     
    // MARK: - Wettschein-Funktionen
    func nextBetNumber() -> Int {
        currentBetNumber += 1
        return currentBetNumber
    }
    
    // Wette zur Statistik hinzufügen
    private func addBetToStatistics(_ bet: Bet) {
        allBets.append(bet)
        // Sortiere nach Wettnummer
        allBets.sort { $0.betSlipNumber > $1.betSlipNumber }
    }
    
    // MARK: - Wettfunktionen
    /// Berechnet die Gewinnquote und den Gewinnbetrag
    private func calculateOddsAndWinAmount(for event: Event, outcome: BetOutcome, betAmount: Double) -> (odds: Double, winAmount: Double) {
        let odds = OddsCalculator.calculateOdds(for: event)
        var selectedOdds: Double
        
        switch outcome {
        case .homeWin: selectedOdds = odds.homeWinOdds
        case .draw: selectedOdds = odds.drawOdds
        case .awayWin: selectedOdds = odds.awayWinOdds
        }
        
        return (selectedOdds, betAmount * selectedOdds)
    }
    
    /// Speichert die Wette in Firestore und fügt sie zur Statistik hinzu
    private func saveBetToFirestore(userId: String, event: Event, betAmount: Double, outcome: BetOutcome, winAmount: Double, betNumber: Int) {
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
        
        dataB.collection("Bets").addDocument(data: betData) { error in
            if let error = error {
                print("Fehler beim Speichern der Wette: \(error)")
            } else {
                print("Wette erfolgreich gespeichert.")
            }
        }
    }
    
    /// Platzieren ohne sofortige Kontostandsänderung
    /// Berechnet Wetteinsatz und aktualisiert Kontostand
    private func processBetPlacement(userBalance: Double) -> Double {
        let totalBetAmount = betAmount
        let newBalance = userBalance - totalBetAmount
        userViewModel?.updateBalance(newBalanceAfterBet: newBalance)
        return newBalance
    }
    
    /// Wette platzieren mit Kontostandaktualisierung
    func placeBets(userBalance: Double) -> Bool {
        guard canPlaceBet(userBalance: userBalance) else { return false }
        
        // Kontostand zuerst aktualisieren
        let newBalance = processBetPlacement(userBalance: userBalance)
        
        // Dann Wetten registrieren
        for bet in bets {
            processAndSaveBet(
                event: bet.event,
                outcome: bet.outcome,
                betAmount: betAmount
            )
            // Event aus der Liste entfernen
            eventViewModel?.removeFromBet(bet.event)
        }
        
        clearBetSlip()
        return true
    }
    
    /// Verarbeiten und Kontostand aktualisieren
    func processBetResult(bet: Bet, actualOutcome: BetOutcome) {
        guard let currentBalance = userViewModel?.userState.balance else { return }
        
        if actualOutcome == bet.outcome {
            // Gewinn: Einsatz behalten und Gewinn gutschreiben
            let winAmount = bet.betAmount * bet.odds
            let newBalance = currentBalance + winAmount
            userViewModel?.updateBalance(newBalanceAfterBet: newBalance)
        } else {
            // Verlust: Nur den Einsatz abziehen
            let newBalance = currentBalance - bet.betAmount
            userViewModel?.updateBalance(newBalanceAfterBet: newBalance)
        }
    }
    
    /// Wette registrieren ohne Kontostandsänderung
    private func processAndSaveBet(event: Event, outcome: BetOutcome, betAmount: Double) {
        let (selectedOdds, winAmount) = calculateOddsAndWinAmount(for: event, outcome: outcome, betAmount: betAmount)
        
        let betNumber = nextBetNumber()
        let newBet = Bet(
            event: event,
            outcome: outcome,
            odds: selectedOdds,
            betAmount: betAmount,
            winAmount: winAmount,
            betSlipNumber: betNumber
        )
        
        // Zur Statistik hinzufügen
        addBetToStatistics(newBet)
        
        // In Firestore speichern
        if let userId = FirebaseAuthManager.shared.userID {
            // Betdaten erstellen
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
            Firestore.firestore().collection("Bets")
                .addDocument(data: betData) { error in
                    if let error = error {
                        print("Fehler beim Speichern der Wette: \(error)")
                    } else {
                        print("Wette erfolgreich gespeichert.")
                    }
                }
        }
    }
    
    /// Überprüft, ob eine Wette platziert werden kann
    func canPlaceBet(userBalance: Double) -> Bool {
        return !bets.isEmpty && betAmount > 0 && betAmount <= userBalance
    }
    
    // Zurücksetzen des Wettscheins
    private func clearBetSlip() {
        bets.removeAll()
        betAmount = 0.0
        totalOdds = 0.0
        potentialWinAmount = 0.0
        selectedBetEvent = nil
        betOutcomeResult = nil
    }
}
