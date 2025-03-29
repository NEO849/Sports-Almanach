//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

/// Verantwortlich für, Wetteinsatz-Verwaltung, Quotenberechnung
@MainActor
class BetViewModel: ObservableObject {
    
    private weak var userViewModel: UserViewModel?
    private weak var eventViewModel: EventViewModel?
    private let bettingService: BettingService
    
    // MARK: - Published Properties für UI-Updates
    /// Aktueller Wetteinsatz - Löst Neuberechnung des potentiellen Gewinns aus
    @Published private(set) var betAmount: Double = 0.0 {
        didSet {
            updatePotentialWinAmount()
        }
    }
    /// Gesamtquote aller ausgewählten Wetten
    @Published private(set) var totalOdds: Double = 1.0 {
        didSet {
            updatePotentialWinAmount()
        }
    }
    @Published private(set) var potentialWinAmount: Double = 0.0
    @Published private(set) var currentBetSlipNumber: Int = 1
    @Published private(set) var bets: [Bet] = [] {
        didSet {
            updateTotalOdds()
        }
    }
    
    // MARK: - Initialisierung
    init(bettingService: BettingService = BettingService()) {
        self.bettingService = bettingService
        Task {
            await loadInitialBetSlipNumber()
        }
    }
    
    // MARK: - Public Interface
    /// Aktualisiert den Wetteinsatz und berechnet möglichen Gewinn neu
    func updateBetAmount(_ amount: Double) {
        betAmount = max(1, amount) // Minimum 1€ Einsatz
    }
    
    /// Fügt eine neue Wette zum Wettschein hinzu
    func addBet(_ bet: Bet) {
        if !bets.contains(where: { $0.event.id == bet.event.id }) {
            bets.append(bet)
        }
    }
    
    /// Entfernt eine Wette aus dem Wettschein
    func removeBet(at index: Int) {
        guard index >= 0 && index < bets.count else { return }
        bets.remove(at: index)
    }
    
    /// Verbindet die benötigten ViewModels
    func setViewModels(user: UserViewModel, event: EventViewModel) {
        self.userViewModel = user
        self.eventViewModel = event
    }
    
    /// Überprüft ob eine Wette platziert werden kann
    func canPlaceBet(userBalance: Double) -> Bool {
        guard !bets.isEmpty else {
            print("❌ Keine Wetten ausgewählt")
            return false
        }
        guard betAmount > 0 else {
            print("❌ Kein Wetteinsatz gewählt")
            return false
        }
        guard betAmount <= userBalance else {
            print("❌ Nicht genügend Guthaben")
            return false
        }
        return true
    }
    
    /// Platziert die Wetten und aktualisiert den Kontostand
    func placeBets(userBalance: Double) async -> Bool {
        guard canPlaceBet(userBalance: userBalance),
              let userId = FirebaseAuthManager.shared.userID else { return false }

        // Wetteinsatz abziehen
        userViewModel?.updateBalance(amount: -betAmount, type: .bet)
        currentBetSlipNumber += 1
        do {
            let betSlip = createBetSlip(userId: userId)
            if let events = eventViewModel?.events {
                let (saved, winAmount) = try await bettingService.processBet(
                    betSlip,
                    userId: userId,
                    events: events
                )
                if saved {
                    // UI bei Gewinn aktualisieren
                    if let winAmount = winAmount {
                        userViewModel?.updateBalance(amount: winAmount, type: .win)
                        print("🎉 Gewinn: \(winAmount)€")
                    }
                    for bet in bets {
                        eventViewModel?.removeFromSelectedEvents(bet.event)
                    }
                    clearBetSlip()
                    return true
                }
            }
            return false
        } catch {
            print("❌ Fehler beim Verarbeiten der Wetten: \(error)")
            return false
        }
    }
    
    // MARK: - Private Helper Functions
    /// Erstellt einen neuen Wettschein
    private func createBetSlip(userId: String) -> BetSlip {
        return BetSlip(
            userId: userId,
            slipNumber: currentBetSlipNumber,
            bets: bets,
            betAmount: betAmount
        )
    }
    
    /// Berechnet den möglichen Gewinn basierend auf Einsatz und Gesamtquote
    private func updatePotentialWinAmount() {
        potentialWinAmount = bettingService.calculatePotentialWin(
            stake: betAmount,
            odds: totalOdds
        )
    }
    
    /// Aktualisiert die Gesamtquote aller Wetten
    private func updateTotalOdds() {
        totalOdds = bettingService.calculateTotalOdds(bets)
    }
    
    /// Lädt die initiale Wettscheinnummer aus der Historie
    private func loadInitialBetSlipNumber() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        do {
            let betSlips = try await bettingService.loadBetSlipHistory(userId: userId)
            let maxNumber = betSlips.map { $0.slipNumber }.max() ?? 0
            await MainActor.run {
                self.currentBetSlipNumber = maxNumber + 1
            }
        } catch {
            print("❌ Fehler beim Laden der Wettscheinnummer: \(error)")
        }
    }
    
    /// Setzt den Wettschein zurück
    private func clearBetSlip() {
        bets.removeAll()
        betAmount = 0.0
        totalOdds = 1.0
        potentialWinAmount = 0.0
    }
}
