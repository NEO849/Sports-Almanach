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
        HStack {
            Text("\(index + 1).") // Fortlaufende Nummer
                .font(.subheadline)
            Text(bet.event.name)
                .font(.headline)
            Spacer()
            Text(bet.outcome.titleGerman)
                .font(.subheadline)
            Spacer()
            Text(String(format: "%.2f", bet.odds))
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}
