//
//  League.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation

enum League: String, Identifiable, CaseIterable, CustomStringConvertible {
    case premierLeague = "English Premier League"
    case superliga = "Albanian Superliga"
    
    var id: String { rawValue }
    
    // CustomStringConvertible Konformität
    var description: String { shortedLeagueName }
    
    var shortedLeagueName: String {
        switch self {
        case .premierLeague:
            return "Engl. Pr. L."
        case .superliga:
            return "Alban. Sup. L."
        }
    }
    
    static var defaultLeague: League { return .premierLeague }
}
