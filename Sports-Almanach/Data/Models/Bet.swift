//
//  Bet.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.10.24.
//

import Foundation

struct Bet: Identifiable, Decodable, Equatable {
    let id: UUID
    let event: Event
    let outcome: BetOutcome
    let odds: Double
    let amount: Double
    var winAmount: Double?
    let timestamp: Date
    
static func == (lhs: Bet, rhs: Bet) -> Bool {
         return lhs.id == rhs.id
     }
}
