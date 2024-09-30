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
                              .resizable() // Bildgröße kann angepasst werden
                              .scaledToFill() // Bild füllt den Rahmen aus, kann aber abgeschnitten werden
                              .frame(maxWidth: .infinity, maxHeight: 162) // Bild nimmt fast die ganze Breite ein
                              .clipShape(RoundedRectangle(cornerRadius: 10)) // Abgerundete Ecken
                      } placeholder: {
                  // Platzhalter während das Bild lädt
                  ProgressView()
                      .frame(height: 32) // Platz für das Bild reservieren
                      .progressViewStyle(CircularProgressViewStyle(tint: .gray)) // Ladebalken
              }
              
              // Vertikaler Abstand zwischen dem Bild und dem Event-Namen
              Spacer().frame(height: 8)
              
              // HStack für den Event-Namen und den Status
              HStack {
                  // VStack für den Event-Namen und das Datum/Uhrzeit
                  VStack(alignment: .leading) {
                      Text(event.name) // Name des Events
                          .font(.headline)
                          .lineLimit(2) // Maximal 2 Zeilen, falls der Name zu lang ist
                      
                      // HStack für Datum und Uhrzeit des Events
                      HStack(spacing: 5) {
                          Text(event.date) // Datum des Events
                              .font(.caption)
                              .foregroundColor(.gray) // Graue Farbe für das Datum
                          
                          Text(event.time) // Uhrzeit des Events
                              .font(.caption)
                              .foregroundColor(.gray) // Graue Farbe für die Uhrzeit
                      }
                  }
                  Spacer() // Platzhalter, um den Status nach rechts zu schieben
                  
                  // Status-Anzeige des Events (z.B. "Beendet", "In Progress", etc.)
                  Text(event.status.currentStatusGerman)
                      .font(.subheadline)
                      .padding(6) // Abstand innerhalb des Status-Tags
                      .background(event.status.color) // Hintergrundfarbe entsprechend dem Status
                      .cornerRadius(8) // Abgerundete Ecken für das Status-Label
                      .foregroundColor(.white) // Weiße Schriftfarbe
              }
          }
          .padding() // Innenabstand um die gesamte Zelle herum
          .overlay(
              // Umrandung der Zelle mit abgerundeten Ecken
              RoundedRectangle(cornerRadius: 15)
                  .stroke(Color.gray, lineWidth: 2)
          )
          .padding(.vertical, 8) // Vertikaler Abstand zwischen den einzelnen Zellen
      }
  }

#Preview {
    let mockEvent = MockEvents.events.first!
    return EventRow(event: mockEvent)
        .padding()
}
