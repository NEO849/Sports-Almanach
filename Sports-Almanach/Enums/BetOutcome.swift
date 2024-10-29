//
//  BetOutcomeResult.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI

/// Enum für die möglichen Ergebnisse einer Wette
enum BetOutcome: String, Identifiable, Decodable {
    case homeWin
    case draw
    case awayWin

    var id: String { rawValue }

    var titleGerman: String {
        switch self {
        case .homeWin:
            return "Heimsieg"
        case .draw:
            return "Remi"
        case .awayWin:
            return "Auswärtssieg"
        }
    }

    var color: Color {
        switch self {
        case .homeWin:
            return .green
        case .draw:
            return .yellow
        case .awayWin:
            return .red
        }
    }
}
