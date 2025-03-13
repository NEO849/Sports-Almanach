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
    // MARK: - Dependencies
    private weak var userViewModel: UserViewModel?
    private weak var eventViewModel: EventViewModel?
    private let repository = BetRepository()
    
    // MARK: - Published Properties
    @Published var betAmount: Double = 0.0 {
        didSet {
            updatePotentialWinAmount()
        }
    }
    @Published var totalOdds: Double = 1.0 {
        didSet {
            updatePotentialWinAmount()
        }
    }
    @Published var potentialWinAmount: Double = 0.0
    @Published var currentBetSlipNumber: Int = 1
    @Published var bets: [Bet] = [] {
        didSet {
            updateTotalOdds()
        }
    }
    
    /// Setzt die ViewModels für die Kommunikation
     func setViewModels(user: UserViewModel, event: EventViewModel) {
         self.userViewModel = user
         self.eventViewModel = event
     }
    
    // MARK: - Prüft ob eine Wette platziert werden kann
    func canPlaceBet(userBalance: Double) -> Bool {
        guard !bets.isEmpty else {
            print("❌ Keine Wetten ausgewählt")
            return false
        }
        
        guard betAmount > 0 else {
            print("❌ Wetteinsatz muss größer als 0 sein")
            return false
        }
        
        let totalRequired = betAmount * Double(bets.count)
        guard totalRequired <= userBalance else {
            print("❌ Nicht genügend Guthaben für Wetteinsatz")
            return false
        }
        
        return true
    }
    
    // MARK: - Private Helper Methods
    /// Aktualisiert den möglichen Gewinnbetrag
    private func updatePotentialWinAmount() {
        potentialWinAmount = SportEventUtils.calculatePotentialWin(
            stake: betAmount * Double(bets.count),
            odds: totalOdds
        )
    }
    
    /// Aktualisiert die Gesamtquote
    func updateTotalOdds() {
        totalOdds = SportEventUtils.calculateTotalOdds(bets)
    }
    
    // MARK: - Public Methods
    /// Platziert die Wetten und aktualisiert den Kontostand
       func placeBets(userBalance: Double) -> Bool {
           guard canPlaceBet(userBalance: userBalance),
                 let userId = FirebaseAuthManager.shared.userID else { return false }
           
           let betAmountTotal = betAmount * Double(bets.count)
           userViewModel?.updateBalance(amount: -betAmountTotal, type: .bet)
           
           currentBetSlipNumber += 1
           
           Task {
               do {
                   // Erstelle BetSlip mit aktualisierten Wetten
                   let updatedBets = bets.map { bet in
                       // Neue Wette mit korrigiertem Einsatz
                       Bet(
                           event: bet.event,
                           userTip: bet.userTip,
                           odds: bet.odds,
                           betAmount: betAmount,
                           timestamp: bet.timestamp,
                           betSlipNumber: currentBetSlipNumber
                       )
                   }
                   
                   let betSlip = BetSlip(
                       userId: userId,
                       slipNumber: currentBetSlipNumber,
                       bets: updatedBets
                   )
                   
                   // Speichere Wettschein
                   try await repository.saveBetSlip(betSlip, userId: userId)
                   
                   // Entferne gewettete Events
                   for bet in bets {
                       eventViewModel?.removeFromSelectedEvents(bet.event)
                   }
                   
                   // Prüft auf Gewinn
                   if let events = eventViewModel?.events {
                       let (isWon, winAmount) = SportEventUtils.evaluateBetSlip(betSlip, events: events)
                       if isWon {
                           await MainActor.run {
                               userViewModel?.updateBalance(amount: winAmount, type: .win)
                               print("🎉 Gewinn: \(winAmount)€ → Neuer Kontostand: \(userViewModel?.userState.balance ?? 0)€")
                           }
                       }
                   }
               } catch {
                   print("❌ Fehler beim Speichern/Auswerten der Wetten: \(error)")
               }
           }

        
        clearBetSlip()
        return true
    }
    
    /// Lädt die letzte Wettscheinnummer
    private func loadBetSlipNumber() {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        Task {
            do {
                let betSlips = try await repository.loadBetSlips(userId: userId)
                if let lastNumber = betSlips.first?.slipNumber {
                    await MainActor.run { currentBetSlipNumber = lastNumber }
                }
            } catch {
                print("❌ Fehler beim Laden der Wettscheinnummer: \(error)")
            }
        }
    }
    
    /// Setzt den Wettschein zurück
    private func clearBetSlip() {
        bets.removeAll()
        betAmount = 0.0
        totalOdds = 1.0 // Reset auf 1.0!
        potentialWinAmount = 0.0
    }
}
