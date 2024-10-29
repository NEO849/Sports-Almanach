//
//  BetSlipView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.10.24.
//

import SwiftUI

struct BetSlipView: View {
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Wettschein")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(betViewModel.bets) { bet in
                            BetSlipRow(index: betViewModel.bets.firstIndex(of: bet) ?? 0, bet: bet)
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 8) {
                    Text("Kontostand: \(userViewModel.balance, specifier: "%.2f")")
                        .padding()
                    
                    if userViewModel.balance > 0 {
                        Slider(value: $betViewModel.betAmount, in: 0...userViewModel.balance, step: 1)
                            .padding()
                    } else {
                        Text("Kein Guthaben verfügbar")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    HStack {
                        Text("Möglicher Gewinn:")
                        Spacer()
                        Text("\(betViewModel.calculatePossibleWin(), specifier: "%.2f")")
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Wetteinsatz:")
                        Spacer()
                        Text("\(betViewModel.betAmount, specifier: "%.2f")")
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Gesamtquote:")
                        Spacer()
                        Text("\(betViewModel.calculateTotalOdds(), specifier: "%.2f")")
                    }
                    .padding(.horizontal)
                }
                Spacer()
                
                // Platzieren der Wette
                Button("Wetten") {
                    if let event = betViewModel.selectedBetEvent,
                       let outcome = betViewModel.betOutcomeResult {
                        betViewModel.placeBet(on: event, outcome: outcome, betAmount: betViewModel.betAmount)
                    }
                    dismiss()
                }
                .font(.title3)
                .padding(.vertical, 2)
                .padding(.horizontal, 2)
                .foregroundColor(.black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.orange, lineWidth: 2)
                )
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.bottom, 48)
                .disabled(betViewModel.betAmount == 0 || betViewModel.selectedBetEvent == nil)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss() // Sheet schließen
                    }
                }
            }
        }
    }
}


#Preview {
    let betViewModel = BetViewModel()
    let userViewModel = UserViewModel()
    
    let mockBet1 = Bet(id: UUID(), event: MockEvents.events[0], outcome: .homeWin, odds: 2.5, amount: 10, timestamp: Date())
    let mockBet2 = Bet(id: UUID(), event: MockEvents.events[1], outcome: .draw, odds: 3.0, amount: 20, timestamp: Date())
    let mockBet3 = Bet(id: UUID(), event: MockEvents.events[2], outcome: .awayWin, odds: 2.0, amount: 15, timestamp: Date())
    let mockBet4 = Bet(id: UUID(), event: MockEvents.events[3], outcome: .homeWin, odds: 1.8, amount: 12, timestamp: Date())
    let mockBet5 = Bet(id: UUID(), event: MockEvents.events[4], outcome: .draw, odds: 2.7, amount: 25, timestamp: Date())
    
    // Weise die Beispielwetten dem betViewModel zu
    betViewModel.bets = [mockBet1, mockBet2, mockBet3, mockBet4, mockBet5]
    
    return BetSlipView()
        .environmentObject(betViewModel)
        .environmentObject(userViewModel)
}
