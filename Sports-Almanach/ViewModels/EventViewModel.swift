//
//  EventViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    private var eventRepository: EventRepository

    /// Dependency Injection
    init(repository: EventRepository = MockEventRepository()) {
        self.eventRepository = repository
        loadEvents()
    }

    func loadEvents() {
        self.events = eventRepository.fetchEvents()
    }
}
