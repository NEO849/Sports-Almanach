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
    let userPick: UserTip
    let odds: Double
    let betAmount: Double
    var winAmount: Double?
    let timestamp: Date
    let betSlipNumber: Int
    var isWon: Bool = false
    
    init(id: UUID = UUID(),
         event: Event,
         userPick: UserTip,
         odds: Double,
         betAmount: Double,
         winAmount: Double? = nil,
         timestamp: Date = Date(),
         betSlipNumber: Int,
         isWon: Bool = false) {
        self.id = id
        self.event = event
        self.userPick = userPick
        self.odds = odds
        self.betAmount = betAmount
        self.winAmount = winAmount
        self.timestamp = timestamp
        self.betSlipNumber = betSlipNumber
        self.isWon = isWon
    }
    
    /// Wertet die Wette aus und aktualisiert isWon
    mutating func evaluate(with eventResult: EventResult?) {
        guard let result = eventResult else { return }
        self.isWon = userPick.rawValue == result.rawValue  // Vergleich der Int-Werte (1,0,2)
        if isWon {
            self.winAmount = betAmount * odds
        }
    }
}
