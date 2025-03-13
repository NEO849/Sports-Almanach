//
//  BetOutcomeResult.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24
//

import Foundation
import SwiftUI

/// Repräsentiert den Tipp des Users (1,0,2)
enum UserTip: Int, Codable, CaseIterable {
    case homeWin = 1
    case draw = 0
    case awayWin = 2
    
    var titleGerman: String {
        switch self {
        case .homeWin: return "1 (Heimsieg)"
        case .draw: return "0 (Unentschieden)"
        case .awayWin: return "2 (Auswärtssieg)"
        }
    }
    
    var color: Color {
        switch self {
        case .homeWin: return .green
        case .draw: return .yellow
        case .awayWin: return .blue
        }
    }
}

/// Repräsentiert das tatsächliche Spielergebnis (1,0,2)
enum EventResult: Int, Codable, Equatable {
    case homeWin = 1
    case draw = 0
    case awayWin = 2
}
