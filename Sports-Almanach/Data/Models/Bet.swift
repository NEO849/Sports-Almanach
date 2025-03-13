//
//  Bet.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.10.24.
//

import Foundation

struct Bet: Identifiable, Codable, Equatable {
    let id: UUID
    let event: Event
    let userTip: UserTip       // User-Tipp als Int (1,0,2)
    let odds: Double
    let betAmount: Double
    var winAmount: Double?
    let timestamp: Date
    let betSlipNumber: Int
    var isWon: Bool = false
    
    init(id: UUID = UUID(),
         event: Event,
         userTip: UserTip,      
         odds: Double,
         betAmount: Double,
         winAmount: Double? = nil,
         timestamp: Date = Date(),
         betSlipNumber: Int,
         isWon: Bool = false) {
        self.id = id
        self.event = event
        self.userTip = userTip
        self.odds = odds
        self.betAmount = betAmount
        self.winAmount = winAmount
        self.timestamp = timestamp
        self.betSlipNumber = betSlipNumber
        self.isWon = isWon
    }
}
