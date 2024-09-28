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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Thumbnail mit Ladebalken
                    AsyncImage(url: URL(string: event.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 280, maxHeight: 140)
                            .cornerRadius(30)
                            .shadow(radius: 5)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: 300, maxHeight: 200)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
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
                        .foregroundColor(.gray)

                    // Stadion
                    Text("Stadion: \(event.stadion)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Teams und Ergebnisse
                    HStack {
                        // Heimmannschaft
                        VStack {
                            Text("Heimmannschaft")
                                .font(.subheadline)
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
                            Text("Auswärtsmann...")
                                .font(.subheadline)
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

                    // Video-Anzeige
                    VideoPlayer(player: AVPlayer(url: URL(string: event.videoURL)!))
                        .frame(height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    Spacer()
                }
                .padding()
                .navigationTitle("Event Details")
            }
        }
    }
}

#Preview {
    let eventViewModel = EventViewModel(repository: MockEventRepository())
    return EventDetailView(event: eventViewModel.events.first!)
        .environmentObject(eventViewModel)
}
