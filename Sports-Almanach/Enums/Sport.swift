//
//  SportPicker.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI

/// Sportarten, die in einem Picker angezeigt werden
enum Sport: String, Identifiable, CaseIterable {
    case football
    
    // Identifizierbar durch die Sportart als ID
    var id: String { rawValue }
    
    // Einfache Erweiterbarkeit
    var titleGerman: String {
        switch self {
        case .football: return "Fußball"
        }
    }
}
