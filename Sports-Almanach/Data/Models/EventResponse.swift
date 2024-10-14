//
//  Untitled.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation

/// Bildet die Struktur der API-Antwort ab, die ein Array von Events unter dem Schlüssel events enthält
struct EventResponse: Decodable {
    let events: [Event]
}
