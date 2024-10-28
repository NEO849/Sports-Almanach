//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            BetView()
                .tabItem {
                    Label("Bet", systemImage: "dollarsign.circle")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Statisitc", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
        }
        
    }
}


#Preview {
    ContentView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
        .environmentObject(BetViewModel())
}
