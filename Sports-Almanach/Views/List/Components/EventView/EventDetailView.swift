//
//  EventDetailView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//  .

import SwiftUI
import WebKit

/// Detaillierte Ansicht eines Events mit farbigem Status-Text
struct EventDetailView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
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
                .padding(.top, 24)
                
                // Titel des Events, Datun/Uhrzeit, Stadion
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.name)
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Datum und Uhrzeit
                    Text("Am: \(eventViewModel.formattedDate(for: event)) um \(eventViewModel.formattedTime(for: event)) Uhr")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Stadion
                    Text("Stadion: \(event.stadion)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.leading, 56)
                
                
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
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        // Ergebnis umwandeln
                        Text("Ergebnis: \(event.homeScore != nil ? String(event.homeScore!) : "0")")
                            .font(.body)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    Spacer()
                    
                    // Auswärtsmannschaft
                    VStack {
                        Text("Auswärtsteam")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("\(event.awayTeam)")
                            .font(.title3)
                            .foregroundColor(.blue)      .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Text("Ergebnis: \(event.awayScore != nil ? String(event.awayScore!) : "0")")
                            .font(.body)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .frame(maxWidth: 340)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Überprüfung auf gültige URL
                if let videoURLString = event.videoURL,
                   let videoURL = URL(string: videoURLString) {
                    WebView(url: videoURL)
                        .frame(width: 340, height: 232)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 12)
                } else {
                    Image("Terrorimage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340, height: 232)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 12)
                }
                Spacer()
            }
            .padding(.top, 8)
        }
      
            .navigationTitle("")
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    let mockEvent = Mocks.events.first!
    let eventViewModel = EventViewModel()
    return EventDetailView(event: mockEvent)
        .environmentObject(eventViewModel)
}
