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
                    List {
                        ForEach(betViewModel.bets.indices, id: \.self) { index in
                            let bet = betViewModel.bets[index]
                            BetSlipRow(index: index, bet: bet)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        // Entferne die Wette aus dem Wettschein
                                        betViewModel.bets.remove(at: index)
                                        // Quoten neu berechnen
                                        betViewModel.updateTotalOdds()
                                        // Event aus der ausgewählten Liste entfernen
                                        if let event = eventViewModel.selectedEvents.first(where: { $0.id == bet.event.id }) {
                                            eventViewModel.removeFromSelectedEvents(event)
                                        }
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.horizontal)
                    
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        // MARK: - Wettschein-Nummer Indikator
                        Text("#\(betViewModel.bets.first?.betSlipNumber ?? 0)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                            .frame(width: 52, height: 38)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.orange, lineWidth: 2)
                            )
                        Text("Wettschein")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
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
    let betViewModel: BetViewModel = {
        let mock = BetViewModel()
        let mockBet1 = Bet(
            id: UUID(),
            event: MockEvents.events[0],
            outcome: .homeWin,
            odds: 2.5,
            betAmount: 10,
            winAmount: 10 * 2.5,
            timestamp: Date(),
            betSlipNumber: 1
        )
        let mockBet2 = Bet(
            id: UUID(),
            event: MockEvents.events[1],
            outcome: .draw,
            odds: 3.0,
            betAmount: 20,
            winAmount: 20 * 3.0,
            timestamp: Date(),
            betSlipNumber: 2
        )
        let mockBet3 = Bet(
            id: UUID(),
            event: MockEvents.events[2],
            outcome: .awayWin,
            odds: 2.0,
            betAmount: 15,
            winAmount: 15 * 2.0,
            timestamp: Date(),
            betSlipNumber: 3
        )
        let mockBet4 = Bet(
            id: UUID(),
            event: MockEvents.events[3],
            outcome: .homeWin,
            odds: 1.8,
            betAmount: 12,
            winAmount: 12 * 1.8,
            timestamp: Date(),
            betSlipNumber: 4
        )
        let mockBet5 = Bet(
            id: UUID(),
            event: MockEvents.events[4],
            outcome: .draw,
            odds: 2.7,
            betAmount: 25,
            winAmount: 25 * 2.7,
            timestamp: Date(),
            betSlipNumber: 5
        )
        mock.bets = [mockBet1, mockBet2, mockBet3, mockBet4, mockBet5]
        return mock
    }()
    
    let userViewModel = UserViewModel()
    let eventViewModel = EventViewModel()
    
    BetSlipView()
        .environmentObject(betViewModel)
        .environmentObject(userViewModel)
        .environmentObject(eventViewModel)
}
