//
//  MainTabView.swift
//  Sports-Almanach
//
//  Native TabView with iOS-26-friendly tab bar styling. Replaces the legacy
//  ContentView, which used inline string labels and inline icon literals
//  scattered across the file.
//

import SwiftUI

struct MainTabView: View {

    @State private var selection: AppTab = .home

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tag(AppTab.home)
                .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.icon) }

            EventView()
                .tag(AppTab.events)
                .tabItem { Label(AppTab.events.title, systemImage: AppTab.events.icon) }

            BetView()
                .tag(AppTab.bet)
                .tabItem { Label(AppTab.bet.title, systemImage: AppTab.bet.icon) }

            StatisticView()
                .tag(AppTab.statistics)
                .tabItem { Label(AppTab.statistics.title, systemImage: AppTab.statistics.icon) }
        }
        .tint(AppTheme.Colors.accent)
    }
}

enum AppTab: String, Hashable, CaseIterable {
    case home, events, bet, statistics

    var icon: String {
        switch self {
        case .home:       return "house.fill"
        case .events:     return "calendar"
        case .bet:        return "dollarsign.circle.fill"
        case .statistics: return "chart.line.uptrend.xyaxis"
        }
    }

    var title: String {
        switch self {
        case .home:       return NSLocalizedString("tab.home",       value: "Home",      comment: "")
        case .events:     return NSLocalizedString("tab.events",     value: "Events",    comment: "")
        case .bet:        return NSLocalizedString("tab.bet",        value: "Wetten",    comment: "")
        case .statistics: return NSLocalizedString("tab.statistics", value: "Statistik", comment: "")
        }
    }
}
