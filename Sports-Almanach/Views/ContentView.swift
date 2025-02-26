//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

/// Main view of the app after login
struct ContentView: View {
    
    // MARK: - Properties
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
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
                            Image(systemName: TabSelection.home.icon)
                            Text(TabSelection.home.title)
                        }
                    EventsView()
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Image(systemName: TabSelection.events.icon)
                            Text(TabSelection.events.title)
                        }
                    BetView()
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Image(systemName: TabSelection.bet.icon)
                            Text(TabSelection.bet.title)
                        }
                    StatisticsView()
                        .environmentObject(userViewModel)
                        .environmentObject(betViewModel)
                        .tabItem {
                            Image(systemName: TabSelection.statistics.icon)
                            Text(TabSelection.statistics.title)
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
        .environmentObject(BetViewModel())
}
