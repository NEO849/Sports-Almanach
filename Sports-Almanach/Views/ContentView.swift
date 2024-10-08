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
            
            FavoriteView()
                .tabItem {
                    Label("Favorits", systemImage: "heart.rectangle")
                }
        }
        
    }
}


#Preview {
    ContentView()
}

