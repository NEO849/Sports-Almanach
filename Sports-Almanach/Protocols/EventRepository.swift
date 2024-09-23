//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 22.09.24.
//

import Foundation

/// Leichtere Hanghabung von MockDaten und API-Call
protocol EventRepository {
    func fetchEvents() -> [Event]
}
