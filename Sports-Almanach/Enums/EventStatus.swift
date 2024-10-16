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
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case soonFinished = "Finished Soon"
    
    
    var id: String { rawValue }
    
    var currentStatusGerman: String {
        switch self {
        case .matchFinished:
            return "Beendet"
        case .notStarted:
            return "Geplant"
        case .inProgress:
            return "Spiel läuft"
        case .soonFinished:
            return "Endet bald"
        }
    }

    var color: Color {
        switch self {
        case .matchFinished:
            return .black
        case .notStarted:
            return .green
        case .inProgress:
            return .yellow
        case .soonFinished:
            return .orange
        }
    }
}
