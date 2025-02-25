//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

/// Main view of the app after login
struct ContentView: View {
    
    // MARK: - Create ViewModels as StateObjects to preserve their state
    @StateObject private var betViewModel = BetViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventViewModel = EventViewModel()

    // Define available navigation tabs
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

                // Main navigation using TabView
                TabView {
                    // Each tab with its required ViewModels
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
        // Make ViewModels available globally
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
