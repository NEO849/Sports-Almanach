//
//  EventsView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//
import SwiftUI

struct EventsView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel // ViewModel als "Source of Truth"
    
    // Auswahl für Sport, Liga und Saison als @State, damit UI aktualisiert wird
    @State private var selectedLeague: League = .premierLeague
    @State private var selectedSeason: Season = .current
    @State private var selectedSport: Sport = .defaultSport
    
    @State private var isLoading = false // Ladezustand für bessere UX
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Hintergrundbild
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer(minLength: 32)
                    
                    // Auswahl-Menüs für Sport, Liga & Saison
                    HStack(spacing: 16) {
                        // Sport-Menü mit korrekter Typ-Inferenz
                        SelectionMenu(
                            title: "Sport",
                            selection: $selectedSport,
                            options: Sport.allCases
                        )
                        
                        // Liga-Menü
                        SelectionMenu(
                            title: "Liga",
                            selection: $selectedLeague,
                            options: League.allCases
                        )
                        
                        // Saison-Menü mit Event-Handler
                        SelectionMenu(
                            title: "Saison",
                            selection: $selectedSeason,
                            options: Season.allCases,
                            onSelect: {
                                Task {
                                    await loadEvents()
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Ladeanzeige während API-Call
                    if isLoading {
                        ProgressView("Lade Events...")
                            .padding()
                    } else {
                        // Event-Liste
                        List(eventViewModel.events, id: \.id) { event in
                            EventRow(event: event)
                        }
                        .listRowBackground(Color.clear)
                        .listStyle(.plain)
                    }
                }
                .deleteDisabled(true)
            }
            .navigationTitle("")
            .task {
                await loadEvents() // Initial Events laden
            }
        }
    }
    
    /// Lädt Events asynchron basierend auf der aktuellen Saison
    private func loadEvents() async {
        isLoading = true
        await eventViewModel.loadEvents(season: selectedSeason)
        isLoading = false
    }
}

/// **Generische Auswahlmenü-View für Sport, Liga & Saison**
struct SelectionMenu<T: Identifiable & CustomStringConvertible>: View {
    let title: String
    @Binding var selection: T
    let options: [T]
    var onSelect: (() -> Void)?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
            Menu {
                ForEach(options) { option in
                    Button(option.description) {
                        selection = option
                        onSelect?()
                    }
                }
            } label: {
                Text(selection.description)
            }
            .padding()
            .frame(minWidth: 110)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.orange, lineWidth: 1)
            )
        }
    }
}

#Preview {
    EventsView()
        .environmentObject(EventViewModel())
}
