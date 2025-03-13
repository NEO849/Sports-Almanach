//
//  BetSlip.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 13.03.25.
//

import Foundation

/// Repräsentiert einen Wettschein mit allen enthaltenen Wetten
struct BetSlip: Identifiable, Codable, Equatable {
    let id: UUID
    let userId: String
    let slipNumber: Int      // Fortlaufende Nummer pro User
    var bets: [Bet]
    let createdAt: Date
    var isWon: Bool
    
    var totalStake: Double { bets.reduce(0) { $0 + $1.betAmount }}
    var totalOdds: Double { bets.reduce(1) { $0 * $1.odds } }
    var potentialWinAmount: Double { totalStake * totalOdds }
    
    init(id: UUID = UUID(),
         userId: String,
         slipNumber: Int,
         bets: [Bet] = [],
         createdAt: Date = Date(),
         isWon: Bool = false) {
        self.id = id
        self.userId = userId
        self.slipNumber = slipNumber
        self.bets = bets
        self.createdAt = createdAt
        self.isWon = isWon
    }
    
    // MARK: - Wettschein Auswertung
    mutating func evaluateAllBets(events: [Event]) -> Double {
        var allBetsWon = true
        
        // Jede Wette im Schein
        for index in bets.indices {
            guard let event = events.first(where: { $0.id == bets[index].event.id }) else { continue }
            let result = SportEventUtils.determineResult(from: event)
            
            bets[index].evaluate(with: result)
            if !bets[index].isWon {
                allBetsWon = false
                break  // Eine verlorene Wette = Schein verloren
            }
        }
        
        isWon = allBetsWon
        return allBetsWon ? potentialWinAmount : 0.0
    }
}
