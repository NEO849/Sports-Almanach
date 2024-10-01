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
                              .scaledToFill() // Füllt den Rahmen aus
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
                  Spacer() // Status nach rechts
                  Text(event.status.currentStatusGerman)
                      .font(.subheadline)
                      .padding(6)
                      .background(event.status.color)
                      .cornerRadius(8)
                      .foregroundColor(.white)
              }
          }
          .padding() // Innenabstand um  gesamte Zelle
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
