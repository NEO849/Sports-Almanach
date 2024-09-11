//
//  EventViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    private var eventRepository = EventRepository()

    init() {
        loadMockEvents()
    }

    func loadMockEvents() {
        self.events = MockEvents.events
    }
}
