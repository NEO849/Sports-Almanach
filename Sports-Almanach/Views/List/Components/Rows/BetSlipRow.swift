//
//  BetSlipRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.10.24.
//

import SwiftUI

struct BetSlipRow: View {
    let index: Int
    let bet: Bet
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("\(index + 1).") // Fortlaufend
                    .font(.subheadline)
                Text(bet.event.name)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", bet.odds))
                    .font(.subheadline)
                    .padding(8)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 2)
                    )
            }
            
            HStack {
                Spacer().frame(width: 16)
                Text(bet.userTip.titleGerman)
                    .font(.subheadline)
                    .frame(width: 100)
                    .padding(8)
                    .background(bet.userTip.color)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(bet.userTip.color, lineWidth: 2)
                    )
                Spacer().frame(width: 16)
                Text("Spielausgang")
                    .font(.footnote)
                    .padding(8)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 2)
                    )
                Spacer()
            }
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    let mockBet = Bet(
        id: UUID(),
        event: Mocks.events.first!,
        userTip: .homeWin,
        odds: 2.5,
        winAmount: 10 * 2.5,
        timestamp: Date()
    )
    BetSlipRow(index: 0, bet: mockBet)
}
