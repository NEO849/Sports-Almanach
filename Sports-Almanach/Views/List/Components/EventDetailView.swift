//
//  EventDetailView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import SwiftUI

/// Detaillierte Ansicht eines Events mit farbigem Status-Text
struct EventDetailView: View {
    
    let event: Event
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                // Thumb-URL
                AsyncImage(url: URL(string: event.thumbURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Titel des Events
                Text(event.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                // Datum und Uhrzeit
                Text("Datum: \(event.date) um \(event.time)")
                    .font(.headline)
                
                // Stadion
                Text("Stadion: \(event.stadion)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Teams und Ergebnisse
                HStack {
                    // Heimmannschaft
                    VStack {
                        Text("Heimmannschaft")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("\(event.homeTeam)")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text("Ergebnis: \(event.homeScore)")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15)
                                    .shadow(radius: 5))
                    
                    Spacer(minLength: 20)
                    
                    // Auswärtsmannschaft
                    VStack {
                        Text("Auswärtsmannschaft")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("\(event.awayTeam)")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text("Ergebnis: \(event.awayScore)")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15)
                                    .shadow(radius: 5))
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 2)
                )
                
                // Farbiger Text (deutsch) für den Status
                Text(event.status.currentStatusGerman)
                    .font(.headline)
                    .padding()
                    .background(event.status.color)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                // Wettquoten-Anzeige
                VStack(alignment: .leading, spacing: 10) {
                    Text("Wettquoten")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Text("Heimsieg:")
                        Spacer()
                        Text("\(String(format: "%.2f", event.homeWinOdds))")
                    }
                    
                    HStack {
                        Text("Unentschieden:")
                        Spacer()
                        Text("\(String(format: "%.2f", event.drawOdds))")
                    }
                    
                    HStack {
                        Text("Auswärtssieg:")
                        Spacer()
                        Text("\(String(format: "%.2f", event.awayWinOdds))")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Event Details")
        }
    }
}

#Preview {
    let eventViewModel = EventViewModel(repository: MockEventRepository()) // MockRepo
    return EventDetailView(event: eventViewModel.events.first!) // Zeigt das erste Mock-Event an
        .environmentObject(eventViewModel)
}
