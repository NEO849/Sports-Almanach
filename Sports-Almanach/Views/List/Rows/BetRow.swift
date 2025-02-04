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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.headline)
            HStack {
                Text("\(eventViewModel.formattedDate(for: event)) um \(eventViewModel.formattedTime(for: event))")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            
            // Quoten berechnen
            let odds = OddsCalculator.calculateOdds(for: event)
            // Binding Übergeben
            OddsRow(selectedOdd: $selectedOdd, event: event, odds: odds)
            HStack {
                Spacer()
                Button(action: {
                    if let outcome = selectedOdd {
                        // Berechnet Quote basierend auf outcome
                        let currentOdds: Double
                        switch outcome {
                        case .homeWin:
                            currentOdds = odds.homeWinOdds
                        case .draw:
                            currentOdds = odds.drawOdds
                        case .awayWin:
                            currentOdds = odds.awayWinOdds
                        }
                        
                        // Neue Wette mit betSlipNumber
                        let bet = Bet(
                            id: UUID(),
                            event: event,
                            outcome: outcome,
                            odds: currentOdds,
                            amount: 0,
                            timestamp: Date(),
                            betSlipNumber: betViewModel.nextBetNumber() 
                        )
                        // Ist Wette bereits im Wettschein vorhanden?
                        if !betViewModel.isBetAlreadyExists(for: event) {
                            betViewModel.bets.append(bet)
                            
                            // Gesamtquote und möglichen Gewinn aktualisieren
                            betViewModel.updateTotalOdds()
                            betViewModel.potentialWinAmount = betViewModel.calculatePossibleWin()
                        } else {
                            showAlert = true
                        }
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2)
        )
        .alert("Wette Existiert bereits!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    BetRow(eventViewModel: EventViewModel(), event: mockEvent)
}
