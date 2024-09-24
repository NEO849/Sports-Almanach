//
//  EventStatus.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI

enum EventStatus: String, Codable, Identifiable, CaseIterable {
    
    case normal
    case scheduled
    case postponed
    case locked
    case cancelled

    // Eindeutige ID für den Status, zum anezigen in der UI
    var id: String { rawValue }
    
    // Switch-Case
    var currentStatusGerman: String {
        switch self {
        case .normal: return "Findet Statt"
        case .scheduled: return "Geplant"
        case .postponed: return "Verschoben"
        case .locked: return "Gesperrt"
        case .cancelled: return "Abgesagt"
        }
    }
    
    /// Gibt die Farbe für den Status zurück
    var color: Color {
        switch self {
        case .normal:
            return .white
        case .scheduled:
            return .green
        case .postponed:
            return .yellow
        case .locked:
            return .red
        case .cancelled:
            return .red
        }
    }
}
