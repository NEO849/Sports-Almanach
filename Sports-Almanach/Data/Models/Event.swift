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
    let date: String
    let time: String
    let venue: String               // Ort, an dem das Event stattfindet
    let official: String            // Schiedsrichter Name
    let status: EventStatus         // Status des Events
    let homeTeamOdds: Double        // Quote für den Sieg des Heimteams
    let drawOdds: Double            // Quote für ein Unentschieden
    let awayTeamOdds: Double        // Quote für den Sieg des Auswärtsteams
    let description: String         // Beschreibung des Events
    let bannerURL: String           // Pfad zum Banner des Events
    let squareURL: String           // Pfad zum quadratischen Bild des Events
}


