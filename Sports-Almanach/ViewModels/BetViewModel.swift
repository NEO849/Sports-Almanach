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
    private let bettingService: BettingService
    
    init(bettingService: BettingService = BettingService()) {
        self.bettingService = bettingService
    }
    
    // MARK: - Published Properties
    @Published private(set) var betAmount: Double = 0.0 {
        didSet {
            updatePotentialWinAmount()
        }
    }
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
    
    // MARK: - Aktualisiert den Wetteinsatz
    /// - Parameter amount: Neuer Wetteinsatz
    func updateBetAmount(_ amount: Double) {
        betAmount = max(0, amount) // Verhindert negative Einsätze
    }
    
    /// Fügt eine neue Wette hinzu
    func addBet(_ bet: Bet) {
        if !bets.contains(where: { $0.event.id == bet.event.id }) {
            bets.append(bet)
        }
    }
    
    /// Entfernt eine Wette anhand des Index
    func removeBet(at index: Int) {
        guard index >= 0 && index < bets.count else { return }
        bets.remove(at: index)
        // Quoten werden automatisch durch didSet aktualisiert
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
    
    // MARK: -  Private Helper Methods
    
    private func createBetSlip(userId: String) -> BetSlip {
        // Erstelle neue Wetten mit aktualisierten Nummern
        let updatedBets = bets.map { bet in
            Bet(
                event: bet.event,
                userTip: bet.userTip,
                odds: bet.odds,
                betAmount: betAmount,
                timestamp: Date(),
                betSlipNumber: currentBetSlipNumber
            )
        }
        
        // Erstelle den Wettschein
        return BetSlip(
            userId: userId,
            slipNumber: currentBetSlipNumber,
            bets: updatedBets
        )
    }
    
    /// Aktualisiert den möglichen Gewinnbetrag
    private func updatePotentialWinAmount() {
        potentialWinAmount = SportEventUtils.calculatePotentialWin(
            stake: betAmount * Double(bets.count),
            odds: totalOdds
        )
    }
    
    private func updateTotalOdds() {
        totalOdds = SportEventUtils.calculateTotalOdds(bets)
    }
    
    // MARK: - Platziert die Wetten und aktualisiert den Kontostand
    func placeBets(userBalance: Double) async -> Bool {
         guard canPlaceBet(userBalance: userBalance),
               let userId = FirebaseAuthManager.shared.userID else { return false }
         
         // Ziehe Wetteinsatz ab
         let betAmountTotal = betAmount * Double(bets.count)
         userViewModel?.updateBalance(amount: -betAmountTotal, type: .bet)
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
                     // Aktualisiere UI bei Gewinn
                     if let winAmount = winAmount {
                         userViewModel?.updateBalance(amount: winAmount, type: .win)
                         print("🎉 Gewinn: \(winAmount)€")
                     }
                     
                     // Entferne gewettete Events
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
    
    /// Lädt die letzte Wettscheinnummer
    private func loadBetSlipNumber() {
          guard let userId = FirebaseAuthManager.shared.userID else { return }
          
          Task {
              do {
                  // Nutzt bettingService
                  let betSlips = try await bettingService.loadBetHistory(userId: userId)
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
        totalOdds = 1.0
        potentialWinAmount = 0.0
    }
}
