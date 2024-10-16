//
//  League.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

/// Verschiedene Ligen
enum League: String, Identifiable, CaseIterable {
    case premierLeague = "English Premier League"
//  case bundesliga = "Albanian Superliga"
    
    var id: String { rawValue }
}
