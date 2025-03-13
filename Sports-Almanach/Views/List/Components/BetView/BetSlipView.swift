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
    @State private var sliderTouched = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                // Hintergrundbild
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    // MARK: - Header mit Wettscheinnummer
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Text("# \(betViewModel.bets.first?.betSlipNumber ?? 0)")
                                .font(.system(size: 24, weight: .bold))
                            Text("   Wettschein")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.orange, lineWidth: 2)
                        )
                        Spacer()
                    }
                    .padding(.top)
                    
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
                    .padding(.horizontal, 32)
                    
                    // Wetteinsatz, Quoten und Gewinn
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Wetteinsatz:            \(betAmount, specifier: "%.2f") €")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, 32)
                                Spacer()
                            }
                            
                            // Slider
                            HStack {
                                Slider(value: $betAmount, in: 0...userViewModel.userState.balance)
                                    .tint(.green)
                                    .onChange(of: betAmount) { _, newValue in
                                        betViewModel.betAmount = newValue
                                        // Button wird nur aktiv mit Betrag
                                        sliderTouched = newValue > 0
                                    }
                            }
                            .padding(.horizontal, 32)
                        }
                        
                        // Gesamtquote und möglicher Gewinn
                        HStack {
                            Text("Gesamtquote:")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.leading, 32)
                            Text("        \(betViewModel.totalOdds, specifier: "%.2f") €")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Möglicher Gewinn:")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.leading, 32)
                            Text("\(betViewModel.potentialWinAmount, specifier: "%.2f") €")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    
                    // Wetten Button
                    PrimaryActionButton(
                        title: "WETTEN",
                        action: {
                            if betViewModel.placeBets(userBalance: userViewModel.userState.balance) {
                                dismiss()
                            } else {
                                alertMessage = "Nicht genügend Guthaben oder ungültiger Wetteinsatz"
                                showAlert = true
                            }
                        },
                        isActive: sliderTouched
                    )
                    .disabled(!betViewModel.canPlaceBet(userBalance: userViewModel.userState.balance))
                    .padding(32)
                }
            }
            .alert("Fehler", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        .task {
            // Beim Erscheinen der View setzen
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
            userPick: .homeWin,
            odds: 2.5,
            betAmount: 10,
            winAmount: 10 * 2.5,
            timestamp: Date(),
            betSlipNumber: 1
        )
        let mockBet2 = Bet(
            id: UUID(),
            event: MockEvents.events[1],
            userPick: .draw,
            odds: 3.0,
            betAmount: 20,
            winAmount: 20 * 3.0,
            timestamp: Date(),
            betSlipNumber: 2
        )
        let mockBet3 = Bet(
            id: UUID(),
            event: MockEvents.events[2],
            userPick: .awayWin,
            odds: 2.0,
            betAmount: 15,
            winAmount: 15 * 2.0,
            timestamp: Date(),
            betSlipNumber: 3
        )
        let mockBet4 = Bet(
            id: UUID(),
            event: MockEvents.events[3],
            userPick: .homeWin,
            odds: 1.8,
            betAmount: 12,
            winAmount: 12 * 1.8,
            timestamp: Date(),
            betSlipNumber: 4
        )
        let mockBet5 = Bet(
            id: UUID(),
            event: MockEvents.events[4],
            userPick: .draw,
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
