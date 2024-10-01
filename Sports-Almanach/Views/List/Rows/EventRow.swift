//
//  EventRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import SwiftUI

struct EventRow: View {
    
    let event: Event
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: event.image)) { image in
                image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 162)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(height: 32)
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
            
            Spacer().frame(height: 8)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8) {
                        Text("\(event.date) um \(event.time)")
                                      .font(.subheadline)
                                      .foregroundColor(.orange)
                    }
                }
                Spacer() // Status nach rechts
                Text(event.status.currentStatusGerman)
                    .font(.subheadline)
                    .padding(6)
                    .background(event.status.color)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
        .padding() // Innenabstand um gesamte Zelle
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.orange, lineWidth: 2)
        )
        .padding(.vertical, 8)
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    return EventRow(event: mockEvent)
        .padding()
}
