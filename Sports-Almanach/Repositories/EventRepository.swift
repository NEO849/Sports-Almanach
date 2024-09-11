//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class EventRepository {
    
    func fetchEvents() -> [Event] {
        // Hier Events aus einer Datenbank oder mittels API abgerufen 
        return MockEvents.events
    }
}
