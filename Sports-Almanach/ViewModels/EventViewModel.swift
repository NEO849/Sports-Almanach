//
//  EventViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedBetEvents: [Event] = [] // Events zum Wetten
    private let eventRepository = EventRepository()
    
    init() {
        loadEvents(for: .current)
    }
    
    func loadEvents(for season: Season) {
        Task {
            await fetchEvents(for: season)
        }
    }
    
    // Abrufen der Events
    func fetchEvents(for season: Season) async {
        await MainActor.run {
            self.isLoading = true
        }
        do {
            let fetchedEvents = try await eventRepository.fetchEvents(for: season)
            // Aktualisiert die Events auf dem Haupt-Thread.
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
    
    // Formatierte Datumsanzeige
     func formattedDate(for event: Event) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd" // Format der API
         if let dateObj = dateFormatter.date(from: event.date) {
             dateFormatter.dateStyle = .medium // Ausgabeformat
             return dateFormatter.string(from: dateObj)
         }
         return event.date
     }
     
     // Formatierte Zeitanzeige
     func formattedTime(for event: Event) -> String {
         let timeFormatter = DateFormatter()
         timeFormatter.dateFormat = "HH:mm:ss" // Format der API
         if let timeObj = timeFormatter.date(from: event.time) {
             timeFormatter.timeStyle = .short // Ausgabeformat "19:00"
             return timeFormatter.string(from: timeObj)
         }
         return event.time
     }
    
    /// Hier Firestore Instanzv hinzufügen und Uodaten
     // Hinzufügen eines Events zur Wettliste
    func addToBet(_ event: Event) {
        if !selectedBetEvents.contains(event) {  // Wenn Event noch nicht vorhanden ist
            selectedBetEvents.append(event)
        }
    }

    // Entfernen eines Events aus der Wettliste
    func removeFromBet(_ event: Event) {
        if let index = selectedBetEvents.firstIndex(of: event) {
            selectedBetEvents.remove(at: index)
        }
    }
 }
