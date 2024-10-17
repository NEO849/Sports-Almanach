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
    @State private var selectedSeason: Season = .season20192020
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                          Text("Entdecke die Welt des Fussballs")
                              .foregroundColor(.white)
                              .font(.title)
                              .padding()
                          
                          HStack {
                              Menu {
                                  ForEach(League.allCases) { league in
                                      Button(league.rawValue) {
                                          selectedLeague = league
                                          //  Eventuell API-Aufruf für die Liga
                                      }
                                  }
                              } label: {
                                  Text("Liga: \(selectedLeague.rawValue)")
                              }
                              .padding()
                              .overlay(
                                  RoundedRectangle(cornerRadius: 8)
                                      .stroke(Color.orange, lineWidth: 2)
                              )


#Preview {
    EventsView()
}
