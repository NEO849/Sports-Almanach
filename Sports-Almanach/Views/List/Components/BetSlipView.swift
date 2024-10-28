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
                    .font(.title)
                    .bold()
                    .padding()
                
//                ScrollView {
//                    VStack(spacing: 4) {
//                        ForEach(Array(betViewModel.bets.enumerated()), id: \.1.id) { index, bet in
//                            BetSlipRow(index: index, bet: bet)
//                        }
//                    }
//                }
                .padding(.horizontal)
                
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
                
                // Button zum Platzieren der Wette
                Button("Wetten") {
                    if let event = betViewModel.selectedBetEvent,
                       let outcome = betViewModel.betOutcomeResult {
                        betViewModel.placeBet(on: event, outcome: outcome, betAmount: betViewModel.betAmount)
                    }
                    dismiss()
                }
                .padding()
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

struct BetSlipView_Previews: PreviewProvider {
    static var previews: some View {
        BetSlipView()
            .environmentObject(BetViewModel())
            .environmentObject(UserViewModel())
    }
}
