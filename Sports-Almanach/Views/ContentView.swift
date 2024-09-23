//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
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
                    Label("Infos", systemImage: "info.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
