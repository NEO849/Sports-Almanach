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
    
    // MARK: - Properties für Statistik und Wettnummern
    @Published var allBets: [Bet] = []
    @Published var currentBetNumber: Int = UserDefaults.standard.integer(forKey: "currentBetNumber") {
        didSet {
            UserDefaults.standard.set(currentBetNumber, forKey: "currentBetNumber")
        }
    }
    @Published var currentBetSlipNumber: Int = UserDefaults.standard.integer(forKey: "currentBetSlipNumber") {
        didSet {
            UserDefaults.standard.set(currentBetSlipNumber, forKey: "currentBetSlipNumber")
        }
    }
    
    // MARK: - Wettschein Properties
    
    /// Gibt die nächste verfügbare Wettscheinnummer zurück
    var nextBetSlipNumber: Int {
        currentBetSlipNumber + 1
    }
    
    /// Gibt die nächste Wettnummer zurück
    private var nextBetNumber: Int {
        currentBetNumber + 1
    }
    
    /// Erhöht die Wettnummer und gibt sie zurück
    func getNextBetNumber() -> Int {
        currentBetNumber += 1
        return currentBetNumber
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
     
    // MARK: - Öffentliche Wettschein-Funktionen
    
    // Wette zur Statistik hinzufügen
    private func addBetToStatistics(_ bet: Bet) {
        allBets.append(bet)
        // Sortiere nach Wettnummer
        allBets.sort { $0.betSlipNumber > $1.betSlipNumber }
    }
    
    // MARK: - Wettfunktionen
    /// Berechnet die Gewinnquote und den Gewinnbetrag
    private func calculateOddsAndWinAmount(for event: Event, outcome: BetOutcome, betAmount: Double) -> (odds: Double, winAmount: Double) {
        let odds = SportEventUtils.calculateOdds(for: event)
        var selectedOdds: Double
        
        switch outcome {
        case .homeWin: selectedOdds = odds.homeWinOdds
        case .draw: selectedOdds = odds.drawOdds
        case .awayWin: selectedOdds = odds.awayWinOdds
        }
        
        return (selectedOdds, betAmount * selectedOdds)
    }
    
    /// Speichert die Wette in Firestore und fügt sie zur Statistik hinzu
    private func saveBetToFirestore(userId: String, bet: Bet) {
        let dataB = Firestore.firestore()
        // Dictionary mit expliziten Typen und Standardwert für winAmount
        let betData: [String: Any] = [
            "userId": userId,
            "eventId": bet.event.id,
            "betAmount": bet.betAmount,
            "outcome": bet.outcome.rawValue,
            "winAmount": bet.winAmount ?? 0.0, // Standardwert 0.0 wenn nil
            "betNumber": bet.betSlipNumber,
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
    private func processBetPlacement(userBalance: Double) {
        // Direkte Berechnung und Aktualisierung des Kontostands
        userViewModel?.updateBalance(newBalanceAfterBet: userBalance - betAmount)
    }

    /// Wette platzieren mit Kontostandaktualisierung
    func placeBets(userBalance: Double) -> Bool {
        guard canPlaceBet(userBalance: userBalance) else { return false }
        
        // Wettscheinnummer erhöhen
        incrementBetSlipNumber()
        
        // Kontostand aktualisieren
        processBetPlacement(userBalance: userBalance)
        
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
        
        let betNumber = getNextBetNumber()
        let newBet = Bet(
            id: UUID(),
            event: event,
            outcome: outcome,
            odds: selectedOdds,
            betAmount: betAmount,
            winAmount: winAmount,
            timestamp: Date(),
            betSlipNumber: betNumber
        )
        
        // Zur Statistik hinzufügen
        addBetToStatistics(newBet)
        
        if let userId = FirebaseAuthManager.shared.userID {
            saveBetToFirestore(userId: userId, bet: newBet)
        }
    }

    /// Überprüft, ob eine Wette platziert werden kann
    func canPlaceBet(userBalance: Double) -> Bool {
        return !bets.isEmpty && betAmount > 0 && betAmount <= userBalance
    }
    
    private func incrementBetSlipNumber() {
        currentBetSlipNumber += 1
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
    
    // MARK: - Wett-Verarbeitung
    
    /// Verarbeitet die Wetten und aktualisiert den Kontostand
    /// - Parameter userBalance: Aktueller Kontostand des Users
    /// - Returns: Bool ob die Wetten erfolgreich platziert wurden
    func placeBetsAlternative(userBalance: Double) -> Bool {
        guard canPlaceBet(userBalance: userBalance),
              let userId = FirebaseAuthManager.shared.userID else {
            return false
        }
        
        userViewModel?.updateBalance(newBalanceAfterBet: userBalance - betAmount)
        
        // Wetten speichern und Ergebnisse prüfen
        Task {
            do {
                for bet in bets {
                    try await BetRepository().saveBet(bet, userId: userId)
                }
                
                // Prüfe Ergebnisse falls alle Events beendet sind
                if let events = eventViewModel?.events,
                   events.allSatisfy({ $0.homeScore != nil && $0.awayScore != nil }) {
                    let (won, newBalance) = try BetRepository().processWagerSlip(
                        bets: bets,
                        events: events,
                        currentBalance: userBalance
                    )
                    
                    if won {
                        await MainActor.run {
                            userViewModel?.updateBalance(newBalanceAfterBet: newBalance)
                        }
                    }
                }
            } catch {
                print("Fehler bei der Wettverarbeitung: \(error)")
            }
        }
        return true
    }
}
