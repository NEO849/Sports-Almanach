//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Tab = .home // Start-Tab
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
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
                
                TabView(selection: $selectedTab) {
                    
                    HomeView()
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(Tab.home)
                    
                    EventsView()
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Label("Events", systemImage: "calendar")
                        }
                        .tag(Tab.events)
                    
                    BetView()
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                        .tabItem {
                            Label("Wetten", systemImage: "dollarsign.circle")
                        }
                        .tag(Tab.bet)
                    
                    StatisticsView()
                        .tabItem {
                            Label("Statistiken", systemImage: "rectangle.and.pencil.and.ellipsis")
                        }
                        .tag(Tab.statistics)
                }
                .accentColor(.orange)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
