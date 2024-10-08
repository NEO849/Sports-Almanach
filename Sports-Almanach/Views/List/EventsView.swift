//
//  EventsView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI


struct EventsView: View {
    
    @StateObject var eventViewModel = EventViewModel()
    
    @State private var selectedSport: Sport = .football
    @State private var selectedLeague: League = .premierLeague
    @State private var selectedSeason: Season = .season2019_2020
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Sportarten
                    Picker("Sportart", selection: $selectedSport) {
                        ForEach(Sport.allCases) { sport in
                            Text(sport.titleGerman).tag(sport)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 44)
                    .background(Color.white)
                    .padding()
                    
                    // Ligen
                    Picker("Liga", selection: $selectedLeague) {
                        ForEach(League.allCases) { league in
                            Text(league.rawValue).tag(league)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 44)
                    .background(Color.white)
                    .padding()
                    
                    // Saison
                    Picker("Saison", selection: $selectedSeason) {
                        ForEach(Season.allCases) { season in
                            Text(season.year).tag(season)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 44)
                    .background(Color.white)
                    .padding()
                    
                    List(eventViewModel.events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            HStack {
                                EventRow(event: event) // Iterriert durch
                                
                                Spacer() // Zwischen Row & Pfeil
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 10)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle(" ")
                }
            }
        }
    }
}


#Preview {
    EventsView()
}
