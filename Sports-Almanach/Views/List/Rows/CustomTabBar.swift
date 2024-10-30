//
//  CustomTabBar.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 30.10.24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @State private var previousTab: Tab = .home
    
    enum Tab: String, CaseIterable {
        case home, events, bet, statistics
    }
    
    var body: some View {
        VStack {
            Group {
                if selectedTab == .home {
                    HomeView()
                } else if selectedTab == .events {
                    EventsView()
                } else if selectedTab == .bet {
                    BetView()
                } else if selectedTab == .statistics {
                    StatisticsView()
                }
            }
            .transition(transition(for: selectedTab)) // Basierend der Richtung
            
            // Tab Leiste
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabButton(tab: tab, selectedTab: $selectedTab, previousTab: $previousTab)
                }
            }
            .padding()
            .background(.clear.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
   //         .padding(.bottom, 16)
        }
        .onChange(of: selectedTab) { newValue in
            previousTab = newValue // Aktuellen Tab als vorherigen setzen
               }
        .animation(.easeInOut, value: selectedTab) // Animation für den Tab-Wechsel
    }
    
     // Funktion für die Übergangsanimation
    private func transition(for tab: Tab) -> AnyTransition {
//        if let previousIndex = Tab.allCases.firstIndex(of: previousTab),
//                 let currentIndex = Tab.allCases.firstIndex(of: tab) {
//                  if currentIndex > previousIndex {
//                      return .move(edge: .trailing) // Vorwärts (von rechts)
//                  } else {
//                      return .move(edge: .leading) // Rückwärts (von links)
//                  }
//              }
    
    if var previousIndex = Tab.allCases.firstIndex(of: previousTab),
          var currentIndex = Tab.allCases.firstIndex(of: tab) {
           return currentIndex > previousIndex ? .move(edge: .trailing) : .move(edge: .leading)
       }
              return .identity // Fallback
          }


struct TabButton: View {
    
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
                    .scaleEffect(selectedTab == tab ? 1.4 : 1.0) // Klick Animation
                Text(title(for: tab))
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
    
    private func title(for tab: CustomTabBar.Tab) -> String {
        switch tab {
        case .home: return "Home"
        case .events: return "Events"
        case .bet: return "Bets"
        case .statistics: return "Statistics"
        }
    }
}

///// Tab-Enumeration, um die Reihenfolge zu definieren
//extension CustomTabBar.Tab: Comparable {
//    static func < (lhs: CustomTabBar.Tab, rhs: CustomTabBar.Tab) -> Bool {
//        return lhs.rawValue < rhs.rawValue
//    }
}
