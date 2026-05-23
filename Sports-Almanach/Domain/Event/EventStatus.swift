//
//  EventStatus.swift
//  Sports-Almanach
//
//  Semantic event lifecycle. SportsDB returns a raw status string with a
//  long, inconsistent vocabulary ("Match Finished", "FT", "Not Started",
//  "Postponed", "Cancelled", ...). We collapse that into four UI-relevant
//  states once at the boundary so views can switch on it cleanly.
//

import SwiftUI

public enum EventStatus: String, Codable, Sendable, CaseIterable {
    case scheduled
    case inProgress
    case finished
    case postponed
    case cancelled

    public init(rawAPIValue: String) {
        let normalized = rawAPIValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        switch normalized {
        case "", "ns", "not started":
            self = .scheduled
        case "ft", "match finished", "finished", "aet", "pen":
            self = .finished
        case "in play", "live", "1h", "2h", "ht":
            self = .inProgress
        case "postponed", "pst", "susp", "suspended":
            self = .postponed
        case "cancelled", "canc", "abd", "abandoned":
            self = .cancelled
        default:
            self = .scheduled
        }
    }

    /// Round-trip back to a representative API string (used on encode).
    public var apiValue: String {
        switch self {
        case .scheduled:  return "Not Started"
        case .inProgress: return "In Play"
        case .finished:   return "Match Finished"
        case .postponed:  return "Postponed"
        case .cancelled:  return "Cancelled"
        }
    }

    public var displayName: String {
        switch self {
        case .scheduled:  return NSLocalizedString("event.status.scheduled",  value: "Scheduled",   comment: "")
        case .inProgress: return NSLocalizedString("event.status.inProgress", value: "Live",        comment: "")
        case .finished:   return NSLocalizedString("event.status.finished",   value: "Finished",    comment: "")
        case .postponed:  return NSLocalizedString("event.status.postponed",  value: "Postponed",   comment: "")
        case .cancelled:  return NSLocalizedString("event.status.cancelled",  value: "Cancelled",   comment: "")
        }
    }

    public var color: Color {
        switch self {
        case .scheduled:  return AppTheme.Colors.info
        case .inProgress: return AppTheme.Colors.success
        case .finished:   return AppTheme.Colors.textSecondary
        case .postponed:  return AppTheme.Colors.warning
        case .cancelled:  return AppTheme.Colors.destructive
        }
    }
}
