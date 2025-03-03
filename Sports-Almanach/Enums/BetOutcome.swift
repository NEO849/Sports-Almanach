//
//  BetOutcomeResult.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUI

/// Enum für die möglichen Ergebnisse einer Wette
/// Implementiert Codable für JSON-Serialisierung und Int für Raw Value Mapping
enum BetOutcome: Int, Codable {
    // MARK: - Cases
    // Raw Values entsprechen der Backend-API
    case draw = 0    // Unentschieden
    case homeWin = 1 // Heimsieg
    case awayWin = 2 // Auswärtssieg
    
    // MARK: - Computed Properties
    /// Liefert die deutsche Übersetzung des Wettergebnisses
    /// Wird für UI-Anzeige verwendet
    var titleGerman: String {
        switch self {
        case .homeWin: return "Heimsieg"
        case .draw: return "Remi"
        case .awayWin: return "Auswärtssieg"
        }
    }

    /// Liefert die Farbe für UI-Visualisierung
    /// Verwendet SwiftUI Color für konsistentes Design
    var color: Color {
        switch self {
        case .homeWin: return .green
        case .draw: return .yellow
        case .awayWin: return .blue
        }
    }
}
