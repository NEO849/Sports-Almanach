//
//  StatisticRankRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 31.03.25.
//

import SwiftUI

/// Zeigt eine einzelne Zeile in der Weltrangliste an
struct StatisticRankRow: View {
    let rank: Int
    let profile: Profile
    
    var body: some View {
        HStack {
            // Rangnummer, Benutzername, Kontostand
            Text("\(rank)")
                .font(.system(.body, design: .monospaced))
                .frame(width: 40, alignment: .leading)
            Text(profile.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "%.2f €", profile.balance))
                .font(.system(.body, design: .monospaced))
                .foregroundColor(profile.balance >= profile.startMoney ? .green : .red)
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#Preview {
    StatisticRankRow(
        rank: 1,
        profile: Mocks.profiles[0]
    )
    .background(.black)
}
