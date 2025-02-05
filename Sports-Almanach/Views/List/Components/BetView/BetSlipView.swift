//
//  BetSlipView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.10.24.
//

import SwiftUI

struct BetSlipView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var betViewModel: BetViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var betAmount: Double = 0.0

    var body: some View {
        
        NavigationStack {
            ZStack {
                // Hintergrundbild
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Ausgelagerte Listen-View
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(betViewModel.bets) { bet in
                                BetSlipRow(index: betViewModel.bets.firstIndex(of: bet) ?? 0, bet: bet)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Wetteinsatz mit Slider
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wetteinsatz: \(betAmount, specifier: "%.2f") €")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Slider(value: $betAmount, in: 0...userViewModel.userState.balance)
                            .tint(.green)
                            .onChange(of: betAmount) { _, newValue in
                                betViewModel.betAmount = newValue
                            }
                    }
                    .padding()
                    
                    // Quoten und Gewinn
                    VStack(spacing: 8) {
                        Text("Gesamtquote: \(betViewModel.totalOdds, specifier: "%.2f")x")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Möglicher Gewinn: \(betViewModel.potentialWinAmount, specifier: "%.2f") €")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    // Wetten Button
                    Button(action: {
                        if betViewModel.placeBets(userBalance: userViewModel.userState.balance) {
                            dismiss()
                        } else {
                            alertMessage = "Nicht genügend Guthaben oder ungültiger Wetteinsatz"
                            showAlert = true
                        }
                    }) {
                        Text("WETTEN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                betViewModel.canPlaceBet(userBalance: userViewModel.userState.balance)
                                    ? Color.green
                                    : Color.gray
                            )
                            .cornerRadius(10)
                    }
                    .disabled(!betViewModel.canPlaceBet(userBalance: userViewModel.userState.balance))
                    .padding()
                }
            }
            .navigationTitle("Wettschein")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Fehler", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        .task {
            // ViewModels beim Erscheinen der View setzen
            betViewModel.setViewModels(user: userViewModel, event: eventViewModel)
        }
    }
}

#Preview {
    // View Model und Mock-Daten in einer Closure vorbereiten
    let preview: some View = {
        let betViewModel = BetViewModel()
        let userViewModel = UserViewModel()
        let eventViewModel = EventViewModel()
        
        // Mock-Wetten erstellen
        let mockBet1 = Bet(id: UUID(), event: MockEvents.events[0], outcome: .homeWin, odds: 2.5, amount: 10, timestamp: Date(), betSlipNumber: 1)
        let mockBet2 = Bet(id: UUID(), event: MockEvents.events[1], outcome: .draw, odds: 3.0, amount: 20, timestamp: Date(), betSlipNumber: 2)
        let mockBet3 = Bet(id: UUID(), event: MockEvents.events[2], outcome: .awayWin, odds: 2.0, amount: 15, timestamp: Date(), betSlipNumber: 3)
        let mockBet4 = Bet(id: UUID(), event: MockEvents.events[3], outcome: .homeWin, odds: 1.8, amount: 12, timestamp: Date(), betSlipNumber: 4)
        let mockBet5 = Bet(id: UUID(), event: MockEvents.events[4], outcome: .draw, odds: 2.7, amount: 25, timestamp: Date(), betSlipNumber: 5)
        
        // Wetten zuweisen
        betViewModel.bets = [mockBet1, mockBet2, mockBet3, mockBet4, mockBet5]
        
        // View mit Environment Objects zurückgeben
        return BetSlipView()
            .environmentObject(betViewModel)
            .environmentObject(userViewModel)
            .environmentObject(eventViewModel)
    }()
    
    return preview
}
