//
//  CustomTabBar.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 30.10.24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @State var previousTab: Tab
    
    enum Tab: String, CaseIterable {
        case home, events, bet, statistics
    }
    
    var body: some View {
        VStack {
            Group {
                // Angezeigt View = ausgewählter Tab
                switch selectedTab {
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
            .transition(tabOrder(for: selectedTab))
            
            // Tab Leiste
            HStack {
                ForEach(Tab.allCases, id: \.self) { currentTab in
                    TabButton(
                        tab: currentTab,
                        selectedTab: $selectedTab,
                        previousTab: $previousTab
                    )
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
    private func tabOrder(for tab: Tab) -> AnyTransition {
//        if let previousIndex = Tab.allCases.firstIndex(of: previousTab),
//                 let currentIndex = Tab.allCases.firstIndex(of: tab) {
//                  if currentIndex > previousIndex {
//                      return .move(edge: .trailing) // Vorwärts (von rechts)
//                  } else {
//                      return .move(edge: .leading) // Rückwärts (von links)
//                  }
//              }
    
    if let previousIndex = Tab.allCases.firstIndex(of: previousTab),
          let currentIndex = Tab.allCases.firstIndex(of: tab) {
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
// extension CustomTabBar.Tab: Comparable {
//    static func < (lhs: CustomTabBar.Tab, rhs: CustomTabBar.Tab) -> Bool {
//        return lhs.rawValue < rhs.rawValue
//    }
}
