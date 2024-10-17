//
//  EventViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var errorMessage: String? 
    @Published var isLoading: Bool = false
    private let eventRepository = EventRepository()
    
    init() {
        Task {
            await fetchEvents(for: .current) // Standardmäßig die aktuelle Saison abrufen
        }
    }
    
    // Funktion zum Abrufen der Events
    func fetchEvents(for season: Season) async {
        isLoading = true
        do {
            let fetchedEvents = try await eventRepository.fetchEvents(for: season)
            DispatchQueue.main.async {
                self.events = fetchedEvents // Events in die Liste speichern
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Fehler beim Abrufen der Events: \(error.localizedDescription)"
                self.isLoading = false
            }
            print("Fehler: \(error)")
        }
    }
}
