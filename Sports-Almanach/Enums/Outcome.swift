//
//  BetOutcomeResult.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI

/// Enum für die möglichen Ergebnisse einer Wette
enum BetOutcome: Int, Codable {
    case draw = 1
    case homeWin = 0
    case awayWin = 2
    case pending = -1
    case invalid = -2
    
    var titleGerman: String {
        switch self {
        case .homeWin: return "1 (Heimsieg)"
        case .draw: return "X (Unentschieden)"
        case .awayWin: return "2 (Auswärtssieg)"
        case .pending: return "Ausstehend"
        case .invalid: return "Ungültig"
        }
    }

    var color: Color {
        switch self {
        case .homeWin: return .green
        case .draw: return .yellow
        case .awayWin: return .blue
        case .pending: return .gray
        case .invalid: return .red
        }
    }
}
