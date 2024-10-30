//
//  League.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation

enum League: String, Identifiable, CaseIterable {
    case premierLeague = "English Premier League"
    case superliga = "Albanian Superliga"
    
    var id: String { rawValue }
    
    var shortedLeagueName: String {
        switch self {
        case .premierLeague:
            return "Engl. Pr. L."
        case .superliga:
            return "Alban. Sup. L."
        }
    }
}
