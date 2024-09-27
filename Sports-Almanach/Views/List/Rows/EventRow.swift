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
        
        HStack {
            // Thumbnail mit Ladebalken
            AsyncImage(url: URL(string: event.thumbURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView() // Ladebalken während des Ladens
                    .frame(width: 60, height: 60)
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
            
            // Event Name, Datum/Uhrzeit
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack(spacing: 5) {
                    Text(event.date)
                        .font(.caption) 
                        .foregroundColor(.gray)
                    
                    Text(event.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 10)
            
            Spacer()
            
            // Status und Pfeil
            HStack {
                Text(event.status.currentStatusGerman)
                    .font(.subheadline)
                    .padding(6)
                    .background(event.status.color)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .frame(width: 100)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 2)
        )
        .padding(.vertical, 8)
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    return EventRow(event: mockEvent)
        .padding()
}
