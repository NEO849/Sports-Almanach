//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    // StateObject für Lifecycle Management
    @StateObject private var betViewModel = BetViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventViewModel = EventViewModel()
    
    enum Tab {
        case home, events, bet, statistics
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                TabView {
                    
                    HomeView()
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    
                    EventsView()
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Events")
                        }
                    
                    BetView()
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Image(systemName: "creditcard")
                            Text("Wetten")
                        }
                    
                    StatisticsView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Statistik")
                        }
                }
                .accentColor(.orange)
            }
        }
        // ViewModels als EnvironmentObjects bereitstellen
        .environmentObject(betViewModel)
        .environmentObject(userViewModel)
        .environmentObject(eventViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
