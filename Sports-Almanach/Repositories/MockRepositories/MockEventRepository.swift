//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class MockEventRepository: EventRepository {
    
    /// Gibt eine Liste von Mock-Events zurück
    func fetchEvents() -> [Event] {
        return MockEvents.events
    }
}
