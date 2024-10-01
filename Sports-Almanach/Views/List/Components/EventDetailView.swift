//
//  EventDetailView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import SwiftUI
import AVKit

/// Detaillierte Ansicht eines Events mit farbigem Status-Text
struct EventDetailView: View {
    
    let event: Event
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                // Thumbnail mit Ladebalken
                AsyncImage(url: URL(string: event.image)) { image in
                    image
                        .resizable()
                        .frame(width: 340, height: 140)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 2)
                        )
                } placeholder: {
                    ProgressView()
                        .background(Color.orange.opacity(0.2))
                        .shadow(radius: 5)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Titel des Events
                Text(event.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Datum und Uhrzeit
                Text("Datum: \(event.date) um \(event.time)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 34)
                
                // Stadion
                Text("Stadion: \(event.stadion)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 34)
                
                // Teams und Ergebnisse
                HStack {
                    // Heimmannschaft
                    VStack {
                        Text("Heimmteam")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("\(event.homeTeam)")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        Text("Ergebnis: \(event.homeScore)")
                            .font(.body)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    
                    Spacer().frame(width: 48)
                    
                    // Auswärtsmannschaft
                    VStack {
                        Text("Auswärtsteam")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("\(event.awayTeam)")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        Text("Ergebnis: \(event.awayScore)")
                            .font(.body)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .frame(maxWidth: 340)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 1)
                )
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Farbiger Text (deutsch) für den Status
                Text(event.status.currentStatusGerman)
                    .font(.headline)
                    .padding()
                    .background(event.status.color)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 34)

                
                // Video-Anzeige
                VideoPlayer(player: AVPlayer(url: URL(string: event.videoURL)!))
                    .frame(maxWidth: 340)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 1)
                    )
                
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .navigationTitle("")
        }
    }
}


#Preview {
    let eventViewModel = EventViewModel(repository: MockEventRepository())
    return EventDetailView(event: eventViewModel.events.first!)
        .environmentObject(eventViewModel)
}
