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
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Text("# \(betViewModel.currentBetSlipNumber)")
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
                    
                    // MARK: - Wettliste
                    List {
                        ForEach(betViewModel.bets.indices, id: \.self) { index in
                            let bet = betViewModel.bets[index]
                            BetSlipRow(index: index, bet: bet)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        betViewModel.removeBet(at: index)
                                        if let event = eventViewModel.selectedEvents.first(where: { $0.id == bet.event.id }) {
                                            eventViewModel.syncDeleteEvent(event)
                                        }
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.horizontal, 32)
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Wetteinsatz: \(betViewModel.betAmount, specifier: "%.2f") €")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, 32)
                                Spacer()
                            }
                            HStack {
                                Slider(value: $betAmount, in: 0...userViewModel.userState.balance)
                                    .tint(.green)
                                    .onChange(of: betAmount) { _, newValue in
                                        betViewModel.updateBetAmount(newValue)
                                        sliderTouched = newValue > 0
                                    }
                            }
                            .padding(.horizontal, 32)
                        }
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
                    
                    PrimaryActionButton(
                        title: "WETTEN",
                        action: {
                            if betViewModel.syncPlaceBets(userBalance: userViewModel.userState.balance) {
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
        .onAppear {
            betViewModel.setViewModels(user: userViewModel, event: eventViewModel)
        }
    }
}

#Preview {
    let betViewModel: BetViewModel = {
        let mock = BetViewModel()
        let mockBets = [
            Bet(
                id: UUID(),
                event: Mocks.events[0],
                userTip: .homeWin,
                odds: 2.5,
                winAmount: 10,
                timestamp: Date()
            ),
            Bet(
                id: UUID(),
                event: Mocks.events[1],
                userTip: .draw,
                odds: 3.0,
                winAmount: 20,
                timestamp: Date()
            ),
            Bet(
                id: UUID(),
                event: Mocks.events[2],
                userTip: .awayWin,
                odds: 2.0,
                winAmount: 15,
                timestamp: Date()
            ),
            Bet(
                id: UUID(),
                event: Mocks.events[3],
                userTip: .homeWin,
                odds: 1.8,
                winAmount: 12,
                timestamp: Date()
            ),
            Bet(
                id: UUID(),
                event: Mocks.events[4],
                userTip: .draw,
                odds: 2.7,
                winAmount: 25,
                timestamp: Date()
            )
        ]
        mockBets.forEach { mock.addBet($0) }
        return mock
    }()
    BetSlipView()
        .environmentObject(betViewModel)
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
