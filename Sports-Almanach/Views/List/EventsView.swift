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
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Welche Saison?")
                        .foregroundColor(.white)
                        .font(.title)         .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 60)
                    
                    HStack(spacing: 12) {
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
                        .frame(minWidth: 140)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                        
                        Menu {
                            ForEach(Season.allCases) { season in
                                Button(season.year) {
                                    selectedSeason = season
                                    Task {
                                        await eventViewModel.fetchEvents(for: selectedSeason)
                                    }
                                }
                            }
                        } label: {
                            Text(" \(selectedSeason.year)")
                        }
                        .padding()
                        .frame(minWidth: 140)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                    }
                    .padding()
                    
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
                                    .tint(.blue)
                                }
                                
                                HStack {
                                    ButtonRow(action: {
                                        if eventViewModel.selectedBetEvents.contains(event) {
                                            eventViewModel.removeFromBet(event) // Entfernen, wenn es bereits hinzugefügt wurde
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
                }
            }
        }
        .task {
            await eventViewModel.fetchEvents(for: selectedSeason)
        }
    }
}

#Preview {
    EventsView()
        .environmentObject(EventViewModel())
}
