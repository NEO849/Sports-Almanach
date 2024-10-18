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
    
    // Abrufen der Events
    func fetchEvents(for season: Season) async {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let fetchedEvents = try await eventRepository.fetchEvents(for: season)
            // Aktualisiert die Events auf dem Haupt-Thread
            await MainActor.run {
                self.events = fetchedEvents
                self.isLoading = false
                print("Geladene Events im ViewModel: \(fetchedEvents)")
            }
        } catch {
            // Fehlerbehandlung auf dem Haupt-Thread
            await MainActor.run {
                self.errorMessage = "Fehler beim Abrufen der Events: \(error.localizedDescription)"
                self.isLoading = false
            }
            print("Fehler: \(error)")
        }
    }
}
