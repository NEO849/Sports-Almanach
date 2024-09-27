//
//  EventsView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI


struct EventsView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    @State private var selectedSport: Sport = .football
    @State private var selectedLeague: League = .premierLeague
    @State private var selectedSeason: Season = .season2019_2020
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
            
                Color.clear
                
                VStack {
                    // Sportarten
                    Picker("Sportart", selection: $selectedSport) {
                        ForEach(Sport.allCases) { sport in
                            Text(sport.titleGerman).tag(sport)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 44)
                    .padding()

                    // Ligen
                    Picker("Liga", selection: $selectedLeague) {
                        ForEach(League.allCases) { league in
                            Text(league.rawValue).tag(league)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 44)
                    .padding()

                    // Saisons
                    Picker("Saison", selection: $selectedSeason) {
                        ForEach(Season.allCases) { season in
                            Text(season.year).tag(season)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 44)
                    .padding()

                    List(eventViewModel.events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventRow(event: event) // Für jedes Event anzeigen
                                .buttonStyle(PlainButtonStyle())
                        }
                        .listRowBackground(Color.clear) 
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .navigationTitle("Events")
                }
            }
        }
    }
}

#Preview {
    let mockEventViewModel = EventViewModel(repository: MockEventRepository())
    return EventsView()
        .environmentObject(mockEventViewModel)
}
