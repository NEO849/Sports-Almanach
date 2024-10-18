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
                            NavigationLink(destination: EventDetailView(event: event)) {
                                HStack {
                                    EventRow(event: event)
                                }
                                .padding(.vertical, 10)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .overlay {
                        if eventViewModel.isLoading {
                            ProgressView()
                        } else if let errorMessage = eventViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        eventViewModel.errorMessage = nil
                                    }
                                }
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
