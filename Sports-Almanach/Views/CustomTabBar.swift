//
//  CustomTabBar.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 30.10.24.
//

import SwiftUI

/// Custom tab bar with animations
struct CustomTabBar: View {
    // Current and previous tab for animation logic
    @Binding var displayedTab: Tab
    @State var previousTab: Tab
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    // Available tabs with raw string values
    enum Tab: String, CaseIterable {
        case home, events, bet, statistics
    }
    
    var body: some View {
        VStack {
            // Content area based on selected tab
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
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                case .events:
                    EventsView()
                        .environmentObject(eventViewModel)
                case .bet:
                    BetView()
                        .environmentObject(userViewModel)
                        .environmentObject(eventViewModel)
                case .statistics:
                    StatisticsView()
                }
            }
            // Animated transition between tabs
            .transition(transitionAnimation(for: displayedTab))
            
            // Custom tab bar buttons
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
    
    // Calculate transition based on tab order
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
    
    /// Single button in the tab bar with animation and styling
    struct TabBarButton: View {
        /// The tab this button represents
        var tab: CustomTabBar.Tab
        /// Currently selected tab (two-way binding)
        @Binding var selectedTab: CustomTabBar.Tab
        /// Previous tab for animation direction
        @Binding var previousTab: CustomTabBar.Tab
        
        var body: some View {
            Button(action: {
                withAnimation(.easeInOut) {
                    selectedTab = tab
                }
            }) {
                VStack {
                    // Icon with dynamic size and color
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
        
        // MARK: - Helper Functions
        /// Returns the appropriate SF Symbol for each tab
        private func icon(for tab: CustomTabBar.Tab) -> String {
            switch tab {
            case .home: return "house"
            case .events: return "calendar"
            case .bet: return "dollarsign.circle"
            case .statistics: return "rectangle.and.pencil.and.ellipsis"
            }
        }
        /// Returns the display text for each tab
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
