//
//  CustomTabBar.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 30.10.24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var displayedTab: Tab
    @State var previousTab: Tab
    
    enum Tab: String, CaseIterable {
        case home, events, bet, statistics
    }
    
    var body: some View {
        VStack {
            Group {
                // /// if / else alternative
                //                if selectedTab == .home {
                //                    HomeView()
                //                } else if selectedTab == .events {
                //                    EventsView()
                //                } else if selectedTab == .bet {
                //                    BetView()
                //                } else if selectedTab == .statistics {
                //                    StatisticsView()
                switch displayedTab {
                case .home:
                    HomeView()
                case .events:
                    EventsView()
                case .bet:
                    BetView()
                case .statistics:
                    StatisticsView()
                }
            }
            // Übergangsanimation basierend der Tab-Reihenfolge
            .transition(transitionAnimation(for: displayedTab))
            
            /// Tab-Leiste
            HStack {
                ForEach(Tab.allCases, id: \.self) { currentTab in
                    TabBarButton(
                        tab: currentTab,
                        selectedTab: $displayedTab,
                        previousTab: $previousTab
                    )
                }
            }
            .padding()
            .padding(.bottom)
        }
        // Wichtig zum Berechnen der Animations Richtung
        .onChange(of: displayedTab) { _, newDesplayedTab in
            previousTab = newDesplayedTab
        }
    }
    
    // Basierend auf der Tab-Reihenfolge
    private func transitionAnimation(for currentTab: Tab) -> AnyTransition {
        // /// if / else alternative
        //            let previousIndex = Tab.allCases.firstIndex(of: previousTab)!
        //            let currentIndex = Tab.allCases.firstIndex(of: tab)!
        //
        //            if currentIndex > previousIndex {
        //                return .move(edge: .trailing) // Vorwärts (von rechts)
        //            } else {
        //                return .move(edge: .leading) // Rückwärts (von links)
        let previousTabIndex = Tab.allCases.firstIndex(of: previousTab)!
        let currentTabIndex = Tab.allCases.firstIndex(of: currentTab)!
        return currentTabIndex > previousTabIndex ? .move(edge: .trailing) : .move(edge: .leading)
    }
    
    struct TabBarButton: View {
        var tab: CustomTabBar.Tab
        @Binding var selectedTab: CustomTabBar.Tab
        @Binding var previousTab: CustomTabBar.Tab
        
        var body: some View {
            Button(action: {
                withAnimation(.easeInOut) {
                    selectedTab = tab
                }
            }) {
                VStack {
                    Image(systemName: icon(for: tab))
                        .font(.system(size: 18))
                        .foregroundColor(selectedTab == tab ? .orange : .blue)
                        .scaleEffect(selectedTab == tab ? 1.4 : 1.0)
                    Text(tabTitle(for: tab))
                        .font(.caption)
                        .foregroundColor(selectedTab == tab ? .orange : .blue)
                }
            }
            .frame(maxWidth: .infinity)
        }
        private func icon(for tab: CustomTabBar.Tab) -> String {
            switch tab {
            case .home: return "house"
            case .events: return "calendar"
            case .bet: return "dollarsign.circle"
            case .statistics: return "rectangle.and.pencil.and.ellipsis"
            }
        }
        private func tabTitle(for tab: CustomTabBar.Tab) -> String {
            switch tab {
            case .home: return "Home"
            case .events: return "Events"
            case .bet: return "Bets"
            case .statistics: return "Statistics"
            }
        }
    }
}
