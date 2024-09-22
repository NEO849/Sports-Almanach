//
//  Event.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

struct Event: Identifiable, Codable {
    let id: String
    let name: String
    let homeTeam: String
    let awayTeam: String
    let date: Date
    let time: String
    let venue: String               // Ort, an dem das Event stattfindet
    let official: String            // Schiedsrichter Name
    let status: EventStatus
    let homeTeamOdds: Double
    let drawOdds: Double
    let awayTeamOdds: Double
    let description: String         // Beschreibung des Events
    let bannerURL: String           // Pfad zum Banner
    let squareURL: String           // Pfad zum quadratischen Bild 
}


