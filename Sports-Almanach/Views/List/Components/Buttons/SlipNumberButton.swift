//
//  LogoutButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.3.2025
//

import SwiftUI

/// Button für die Anzeige der Wettscheinnummer und Status in der StatisticsView
struct SlipNumberButton: View {
    let betSlip: BetSlip
    @State private var showDetails = false

    var body: some View {
        Button {
            showDetails.toggle()
        } label: {
            HStack(spacing: 4) {
                Text("#\(betSlip.slipNumber)")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                Text(betSlip.isWon ? "Won" : "Fail")
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 4)
                    .background(
                        Capsule()
                            .fill(betSlip.isWon ? .green : .red)
                    )
            }
            .padding(12)
            .frame(height: 40)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 1)
            )
        }
        .foregroundColor(.white)
        .sheet(isPresented: $showDetails) {
   //         BetSlipDetailSheet(betSlip: betSlip)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        SlipNumberButton(
            betSlip: BetSlip(
                userId: "test",
                slipNumber: 1,
                bets: [],
                isWon: true
            )
        )
        SlipNumberButton(
            betSlip: BetSlip(
                userId: "test",
                slipNumber: 2,
                bets: [],
                isWon: false
            )
        )
    }
    .padding()
    .background(.black)
}
