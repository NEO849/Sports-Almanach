//
//  EventStatus.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI

enum EventStatus: String, Codable, Identifiable, CaseIterable {
    case matchFinished = "Match Finished"
    case started = "Started"
    case inProgress = "In Progress"
    case postponed = "Postponed"
    case locked = "Locked"
    case cancelled = "Cancelled"
 
    
    var id: String { rawValue }
    
    var currentStatusGerman: String {
        switch self {
        case .matchFinished:
            return "Beendet"
        case .started:
            return "Startet bald"
        case .inProgress:
            return "Spiel läuft"
        case .postponed:
            return "Verschoben"
        case .locked:
            return "Gesperrt"
        case .cancelled:
            return "Abgesagt"
        }
    }

    var color: Color {
        switch self {
        case .matchFinished:
            return .orange
        case .started:
            return .green
        case .inProgress:
            return .yellow
        case .postponed:
            return .red
        case .locked:
            return .red
        case .cancelled:
            return .red
        }
    }
}
