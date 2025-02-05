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
    let betAmount: Double
    var winAmount: Double?
    let timestamp: Date
    let betSlipNumber: Int
    
    // Custom init
    init(id: UUID = UUID(),
         event: Event,
         outcome: BetOutcome,
         odds: Double,
         betAmount: Double,
         winAmount: Double?,
         timestamp: Date = Date(),
         betSlipNumber: Int) {
        self.id = id
        self.event = event
        self.outcome = outcome
        self.odds = odds
        self.betAmount = betAmount
        self.winAmount = winAmount
        self.timestamp = timestamp
        self.betSlipNumber = betSlipNumber
    }
}
