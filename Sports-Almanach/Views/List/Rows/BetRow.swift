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
    
    /// Ob eine Wette ausgewählt wurde
    private var isButtonActive: Bool {
        selectedOdd != nil
    }
    
    /// Berechnet die aktuelle Quote basierend auf der Auswahl
    private func getCurrentOdds(outcome: BetOutcome, odds: (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double)) -> Double {
        switch outcome {
        case .homeWin: return odds.homeWinOdds
        case .draw: return odds.drawOdds
        case .awayWin: return odds.awayWinOdds
        }
    }
    
    /// Zur Auswahl einer Quote
    private func selectOdd(_ oddType: BetOutcome) {
        if selectedOdd == oddType {
            selectedOdd = nil
        } else {
            selectedOdd = oddType
        }
    }
    
    /// Erstellt eine neue Wette
    private func createBet(odds: (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double)) {
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
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.headline)
                .padding(.horizontal, 16)
            
            HStack {
                Text("\(eventViewModel.formattedDate(for: event)) um \(eventViewModel.formattedTime(for: event))")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)
            
            // Quoten Grid
            let odds = OddsCalculator.calculateOdds(for: event)
            oddsGrid(odds: odds)
                .padding(.horizontal, 12)
            
            HStack {
                Spacer()
                PrimaryActionButton(
                    title: "Zum Wettschein",
                    action: { createBet(odds: odds) },
                    isActive: selectedOdd != nil
                )
                .frame(width: 200, height: 40)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2)
        )
        .padding(.horizontal, 16)
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
}

// MARK: - QuoteRow View
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

// MARK: - Preview
#Preview {
    let mockEvent = MockEvents.events.first!
    return BetRow(eventViewModel: EventViewModel(), event: mockEvent)
        .environmentObject(BetViewModel())
}
