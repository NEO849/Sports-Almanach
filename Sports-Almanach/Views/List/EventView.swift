//
//  EventsView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct EventView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel // "Source of Truth"
    
    // @State, damit UI aktualisiert wird
    @State private var selectedLeague: League = .premierLeague
    @State private var selectedSeason: Season = .defaultSeason
    @State private var selectedSport: Sport = .defaultSport
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack(spacing: 12) {
                        Group {
                            SelectionMenu(
                                selection: $selectedSport,
                                options: Sport.allCases,
                                placeholder: "Sport"
                            )
                            SelectionMenu(
                                selection: $selectedLeague,
                                options: League.allCases,
                                placeholder: "Liga"
                            )
                            SelectionMenu(
                                selection: $selectedSeason,
                                options: Season.allCases,
                                placeholder: "Saison",
                                onSelect: {
                                    Task { await loadEvents() }
                                },
                                textColor: .green
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                    }
                    .padding(.top, 38)
                    .padding(.horizontal, 20)
                    
                    if isLoading {
                        ProgressView("Lade Events...")
                            .padding()
                    } else {
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
        }
        .task {
            await loadEvents()
        }
        .onDisappear {
            eventViewModel.cancelLoadingTasks()
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
    @Binding var selection: T
    let options: [T]
    let placeholder: String
    var onSelect: (() -> Void)?
    var textColor: Color = .white // Default Farbe
    
    var body: some View {
        Menu {
            ForEach(options) { option in
                Button(option.description) {
                    selection = option
                    onSelect?()
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selection.description)
                    .foregroundColor(textColor)
                    .font(.subheadline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange, lineWidth: 1)
        )
    }
}

#Preview {
    EventView()
        .environmentObject(EventViewModel())
}
