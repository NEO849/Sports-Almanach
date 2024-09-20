//
//  EventStatus.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI

enum EventStatus: String, Codable {
    
    case scheduled = "geplant"
    case postponed = "verschoben"
    case locked = "gesperrt"
    case cancelled = "abgesagt"  

    /// Gibt die Farbe für den Status zurück
    var color: Color {
        switch self {
        case .scheduled:
            return .green
        case .postponed:
            return .yellow
        case .locked:
            return .red
        case .cancelled:
            return .gray
        }
    }
}
