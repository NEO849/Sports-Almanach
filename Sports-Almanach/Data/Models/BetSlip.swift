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
    let slipNumber: Int
    var bets: [Bet]
    let createdAt: Date
    var isWon: Bool
    
    // MARK: - Berechnet den Gesamteinsatz, Gesamtquote und den möglichen Gewinn
    var totalStake: Double {
        SportEventUtils.calculateTotalStake(bets)
    }
    var totalOdds: Double {
        SportEventUtils.calculateTotalOdds(bets)
    }
    var potentialWinAmount: Double {
        SportEventUtils.calculatePotentialWin(stake: totalStake, odds: totalOdds)
    }
    
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
}
