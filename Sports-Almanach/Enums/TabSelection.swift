//
//  TabSelection.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 26.02.25.
//

import SwiftUI

/// Enum for defining the main navigation tabs in the app
/// - Enables centralized management of all tab-related properties
/// - Improves reusability and simplifies changes to the navigation structure
/// - Follows the Single Responsibility Principle by isolating navigation concerns
enum TabSelection: String, CaseIterable {
    case home, events, bet, statistics
    
    /// Returns the appropriate SF Symbol name for each tab
    /// - Returns: String containing the SF Symbol name
    var icon: String {
        switch self {
        case .home: return "house"
        case .events: return "calendar"
        case .bet: return "creditcard"
        case .statistics: return "chart.bar"
        }
    }
    
    /// Returns the localized display name for each tab
    /// - Returns: String containing the displayed tab name
    /// - Note: This could be extended to support multiple languages using NSLocalizedString
    var title: String {
        switch self {
        case .home: return "Home"
        case .events: return "Events"
        case .bet: return "Wetten"
        case .statistics: return "Statistik"
        }
    }
}
