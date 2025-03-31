//
//  StatisticBetDetailView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 31.03.25.
//

import SwiftUI

/// Detailansicht eines einzelnen Wettscheins
struct StatisticSlipDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    let betSlip: BetSlip
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Wettschein #\(betSlip.slipNumber)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.leading)
                    HStack(spacing: 16) {
                        Text("Gewonnen")
                            .foregroundColor(.green)
                            .opacity(betSlip.isWon ? 1 : 0.3)
                        
                        Text("Verloren")
                            .foregroundColor(.red)
                            .opacity(betSlip.isWon ? 0.3 : 1)
                    }
                    .font(.headline)
                    .padding(.leading)
                    
                    // Wetteinsatz und Gewinninfo
                    HStack(spacing: 8) {
                        Text("Einsatz: \(String(format: "%.2f €", betSlip.betAmount))")
                            .foregroundColor(.red)
                        
                        if let winAmount = betSlip.winAmount {
                            Text("Gewinn: \(String(format: "%.2f €", winAmount))")
                            .foregroundColor(.green)
                        }
                        
                        let totalOdds = betSlip.bets.reduce(1.0) { $0 * $1.odds }
                        Text("Gesamtquote: \(String(format: "%.2f", totalOdds))")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical)
                    
                    // Scrollbare Liste der Einzelwetten
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(betSlip.bets.enumerated()), id: \.element.id) { index, bet in
                                BetSlipRow(index: index, bet: bet)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StatisticSlipDetailView(betSlip: Mocks.betSlips[0])
}
