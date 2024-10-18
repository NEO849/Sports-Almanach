//
//  OddsRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 28.09.24.
//

import SwiftUI

struct OddsRow: View {
    
    let event: Event
    
    var body: some View {
        
        // Wettquoten-Anzeige
        VStack(alignment: .leading, spacing: 10) {
            Text("Wettquoten")
                .font(.title2)
                .bold()
            
            // Nil-Koaleszenz-Operator
            let odds = OddsCalculator.calculateOdds(homeScore: event.homeScore ?? 0, awayScore: event.awayScore ?? 0)
            
            HStack {
                Text("Heimsieg:")
                Spacer()
                Text("\(String(format: "%.2f", odds.homeWinOdds))")
            }
            
            HStack {
                Text("Unentschieden:")
                Spacer()
                Text("\(String(format: "%.2f", odds.drawOdds))")
            }
            
            HStack {
                Text("Auswärtssieg:")
                Spacer()
                Text("\(String(format: "%.2f", odds.awayWinOdds))")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center) // Vertical Mittig
        
        Spacer()
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    return OddsRow(event: mockEvent)
}
