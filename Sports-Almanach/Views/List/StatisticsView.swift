//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedBet: Bet?
    @State private var showBetDetails = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    if betViewModel.allBets.isEmpty {
                        Text("Keine Wettscheine vorhanden")
                            .font(.title2)
                            .foregroundColor(.white)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(betViewModel.allBets) { bet in
                                    BetHistoryRow(bet: bet)
                                        .onTapGesture {
                                            selectedBet = bet
                                            showBetDetails = true
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Wettscheine")
            .sheet(isPresented: $showBetDetails) {
                if let bet = selectedBet {
                    BetDetailsView(bet: bet)
                        .environmentObject(betViewModel)
                        .environmentObject(userViewModel)
                }
            }
        }
    }
}

// MARK: - BetHistoryRow
struct BetHistoryRow: View {
    let bet: Bet
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("#\(bet.betSlipNumber)")
                    .font(.headline)
                Text(bet.event.name)
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(bet.amount, specifier: "%.2f") €")
                    .font(.headline)
                Text("Quote: \(bet.odds, specifier: "%.2f")")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue.opacity(0.3))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    let betViewModel = BetViewModel()
    let userViewModel = UserViewModel()
    
    betViewModel.allBets = [
        Bet(event: MockEvents.events[0], outcome: .homeWin, odds: 2.5, amount: 10, winAmount: 25, betSlipNumber: 1),
        Bet(event: MockEvents.events[1], outcome: .draw, odds: 3.0, amount: 20, winAmount: 60, betSlipNumber: 2)
    ]
    
    return StatisticsView()
        .environmentObject(betViewModel)
        .environmentObject(userViewModel)
}
