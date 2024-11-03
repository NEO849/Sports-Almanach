//
//  EventsView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct EventsView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var selectedLeague: League = .premierLeague
    @State private var selectedSeason: Season = .current
    @State private var selectedSport: Sport = .defaultSport
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 32)
                
                HStack(spacing: 16) {
                    
                    // Sport-Auswahl mit Label
                    VStack {
                        Text("Sport")
                            .font(.caption)
                            .foregroundColor(.white)
                        Menu {
                            ForEach(Sport.allCases) { sport in
                                Button(sport.rawValue) {
                                    selectedSport = sport
                                }
                            }
                        } label: {
                            Text(" \(selectedSport.rawValue)")
                        }
                        .padding()
                        .frame(minWidth: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                    }
                    
                    // Liga-Auswahl
                    VStack {
                        Text("Liga")
                            .font(.caption)
                            .foregroundColor(.white)
                        Menu {
                            ForEach(League.allCases) { league in
                                Button(league.rawValue) {
                                    selectedLeague = league
                                }
                            }
                        } label: {
                            Text(" \(selectedLeague.shortedLeagueName)")
                        }
                        .padding()
                        .frame(minWidth: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                    }
                    
                    // Saison-Auswahl
                    VStack {
                        Text("Saison")
                            .font(.caption)
                            .foregroundColor(.white)
                        Menu {
                            ForEach(Season.allCases) { season in
                                Button(season.year) {
                                    selectedSeason = season
                                    Task {
                                        await eventViewModel.loadEvents(for: selectedSeason)
                                    }
                                }
                            }
                        } label: {
                            Text(" \(selectedSeason.year)")
                        }
                        .padding()
                        .frame(minWidth: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                List {
                    ForEach(eventViewModel.events) { event in
                        VStack(alignment: .leading) {
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventRow(event: event)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    eventViewModel.removeFromBet(event)
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    eventViewModel.addToBet(event)
                                } label: {
                                    Label("Zur Wette", systemImage: "plus.circle.fill")
                                }
                                .tint(.green)
                            }
                            
                            HStack {
                                SelectedBetButton(action: {
                                    if eventViewModel.selectedBetEvents.contains(event) {
                                        eventViewModel.removeFromBet(event) // Entfernen, wenn es bereits vorhanden
                                    } else {
                                        eventViewModel.addToBet(event) // Ansonsten...
                                    }
                                }, eventViewModel: eventViewModel, event: event)
                                .frame(maxWidth: .infinity)
                                .padding(.trailing, 16)
                            }
                            .onReceive(eventViewModel.$selectedBetEvents) { _ in }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("")
                Spacer()
            }
        }
        .task {
            await eventViewModel.loadEvents(for: selectedSeason)
        }
    }
    
}

#Preview {
    EventsView()
        .environmentObject(EventViewModel())
}
