//
//  EventRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 16.03.25.
//

import SwiftUI

/// Detailansicht für einen einzelnen Wettschein
struct HistoryBetSlipView: View {
    let betSlip: Bet
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.9)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Wettschein #\(betSlip.betSlipNumber)")
                            .font(.title2)
                            .foregroundColor(.orange)
                        EventDetailsSection(bet: betSlip)
                        BetDetailsSection(bet: betSlip)
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schließen") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

// MARK: - Helper Views
private struct EventDetailsSection: View {
    let bet: Bet
    
    var body: some View {
        VStack(spacing: 8) {
            Text(bet.event.name)
                .font(.headline)
            Text("\(bet.event.date) um \(bet.event.time)")
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }
}

private struct BetDetailsSection: View {
    let bet: Bet
    
    // Zahlen als String mit 2 Dezimalstellen
       private func formatAmount(_ amount: Double) -> String {
           String(format: "%.2f", amount)
       }
    
    var body: some View {
        VStack(spacing: 12) {
            DetailRow(title: "Wetteinsatz:", value: "\(formatAmount(bet.betAmount)) €")
            DetailRow(title: "Quote:", value: formatAmount(bet.odds))
            DetailRow(title: "Tipp:", value: bet.userTip.titleGerman)
            if let winAmount = bet.winAmount {
                DetailRow(title: "Möglicher Gewinn:", value: "\(formatAmount(winAmount)) €")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
/// Einzelne Detail-Zeile
private struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    let mockBet = Bet(
        id: UUID(),
        event: MockEvents.events[0],
        userTip: .homeWin,
        odds: 2.5,
        betAmount: 10,
        winAmount: 25.0,
        timestamp: Date(),
        betSlipNumber: 1
    )
    HistoryBetSlipView(betSlip: mockBet)
}
