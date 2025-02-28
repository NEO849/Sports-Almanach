//
//  BetRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.10.24.
//

import SwiftUI

struct BetRow: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    @EnvironmentObject var betViewModel: BetViewModel
    @State private var selectedOdd: BetOutcome?
    @State private var showAlert = false
    let event: Event
    
    // MARK: - Hilfsfunktionen
    
    /// Berechnet die aktuelle Quote basierend auf der Auswahl
    private func getCurrentOdds(outcome: BetOutcome, odds: (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double)) -> Double {
        switch outcome {
        case .homeWin: return odds.homeWinOdds
        case .draw: return odds.drawOdds
        case .awayWin: return odds.awayWinOdds
        }
    }
    
    /// Zur Auswahl einer Quote mit Toggle-Funktionalität
    private func selectOdd(_ oddType: BetOutcome) {
        if selectedOdd == oddType {
            selectedOdd = nil  // Wenn bereits ausgewählt, deselektieren
        } else {
            selectedOdd = oddType
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.headline)
            HStack {
                Text("\(eventViewModel.formattedDate(for: event)) um \(eventViewModel.formattedTime(for: event))")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            
            // Quoten Grid
            let odds = OddsCalculator.calculateOdds(for: event)
            oddsGrid(odds: odds)
            
            // Wettschein Button
            wettscheinButton(odds: odds)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2)
        )
        .alert("Wette existiert bereits!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    // MARK: - Subviews
    
    /// Grid für die Quotenanzeige
    private func oddsGrid(odds: (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double)) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            QuoteRow(title: "Heimsieg:", odds: odds.homeWinOdds, isSelected: selectedOdd == .homeWin) {
                selectOdd(.homeWin)
            }
            
            QuoteRow(title: "Unentschieden:", odds: odds.drawOdds, isSelected: selectedOdd == .draw) {
                selectOdd(.draw)
            }
            
            QuoteRow(title: "Auswärtssieg:", odds: odds.awayWinOdds, isSelected: selectedOdd == .awayWin) {
                selectOdd(.awayWin)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    /// Einzelne Quote-Zeile
    private struct QuoteRow: View {
        let title: String
        let odds: Double
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            HStack {
                Text(title)
                Spacer()
                Text(String(format: "%.2f", odds))
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(.orange)
                    .onTapGesture(perform: action)
            }
        }
    }
    
    /// Button zum Hinzufügen zum Wettschein
    private func wettscheinButton(odds: (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double)) -> some View {
        HStack {
            Spacer()
            Button(action: {
                guard let outcome = selectedOdd else { return }
                
                let currentOdds = getCurrentOdds(outcome: outcome, odds: odds)
                let bet = Bet(
                    id: UUID(),
                    event: event,
                    outcome: outcome,  
                    odds: currentOdds,
                    betAmount: betViewModel.betAmount, 
                    winAmount: betViewModel.betAmount * currentOdds, 
                    timestamp: Date(),
                    betSlipNumber: betViewModel.nextBetSlipNumber 
                )
                
                if !betViewModel.isBetAlreadyExists(for: event) {
                    betViewModel.bets.append(bet)
                    betViewModel.updateTotalOdds()
                    betViewModel.potentialWinAmount = betViewModel.calculatePossibleWin()
                } else {
                    showAlert = true
                }
            }) {
                Text("Zum Wettschein Hinzufügen")
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 1)
            )
            .buttonStyle(.borderedProminent)
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    BetRow(eventViewModel: EventViewModel(), event: mockEvent)
}
