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
            
            let odds = OddsCalculator.calculateOdds(for: event)
            
            HStack {
                Text("Heimsieg:")
                Spacer()
                Text("\(String(format: "%.2f", odds.homeWinOdds))")
                Image(systemName: isHomeWinSelected ? "checkmark.square" : "square")
                    .foregroundColor(.orange)
                                   .onTapGesture {
                                       isHomeWinSelected.toggle()
                                   }
            }
            
            HStack {
                Text("Unentschieden:")
                Spacer()
                Text("\(String(format: "%.2f", odds.drawOdds))")
                Image(systemName: isDrawSelected ? "checkmark.square" : "square")
                                   .foregroundColor(.orange)
                                   .onTapGesture {
                                       isDrawSelected.toggle()
                                   }
            }
            
            HStack {
                Text("Auswärtssieg:")
                Spacer()
                Text("\(String(format: "%.2f", odds.awayWinOdds))")
                Image(systemName: isAwayWinSelected ? "checkmark.square" : "square")
                                   .foregroundColor(.orange)
                                   .onTapGesture {
                                       isAwayWinSelected.toggle()
                                   }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
        
        Spacer()
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    return OddsRow(event: mockEvent)
}
