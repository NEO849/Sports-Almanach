//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

/// Die Hauptansicht der App, die die Tabs enthält

struct ContentView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var splashViewModel: SplashViewModel
    
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            BetView()
                .tabItem {
                    Label("Bet", systemImage: "dollarsign.circle")
                }
            
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            InfoView()
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
        .environmentObject(SplashViewModel())
}
