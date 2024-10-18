//
//  League.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

/// Verschiedene Ligen
enum League: String, Identifiable, CaseIterable {
    case premierLeague = "English Premier League"
    
    var id: String { rawValue }
    
    var shortedLeagueName: String {
        switch self {
        case .premierLeague:
            return "Engl. Premier L."
        }
    }
}
