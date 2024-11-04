//
//  EventViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedBetEvents: [Event] = []
    @Published var selectedEvents: [Event] = []
    private let eventRepository = EventRepository()
    private let datab = Firestore.firestore()
    
    /// Mit der aktuellen Eventsseasson
    init() {
        loadingEvents(for: .current)
        Task {
            await fetchUserEvents()
        }
    }
    
    /// Lädt die Events für die angegebene Saison asynchron
    func loadingEvents(for season: Season) {
        Task {
            await loadEvents(for: season)
        }
    }
    
    /// Abrufen der Events aus dem Repo
    func loadEvents(for season: Season) async {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let fetchedEvents = try await eventRepository.fetchEvents(for: season)
            // Aktualisiert die Events auf dem Haupt-Thread.
            await MainActor.run {
                self.events = fetchedEvents
                self.isLoading = false
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
    
    ///   Speichert ausgewähltes Event im Nutzerprofil in Firestore
    func saveEventToUserProfile(event: Event) async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        
        let profileRef = datab.collection("Profile").document(userId).collection("events").document(event.id)
        
        do {
            try await profileRef.setData(from: event)
            await fetchUserEvents()
            print("Event erfolgreich im Profil gespeichert.")
        } catch {
            print("Fehler beim Speichern des Events: \(error.localizedDescription)")
        }
    }
    
    ///   Löscht ausgewähltes Event im Nutzerprofil in Firestore
    func deleteEventFromUserProfile(eventId: String) async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        
        let eventRef = datab.collection("Profile").document(userId).collection("events").document(eventId)
        
        do {
            try await eventRef.delete()
            await fetchUserEvents()
            print("Event mit ID \(eventId) erfolgreich gelöscht.")
        } catch {
            print("Fehler beim Löschen des Events: \(error.localizedDescription)")
        }
    }
    
    /// Lädt die Events des Benutzers aus Firestore
    func fetchUserEvents() async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        
        let profileRef = datab.collection("Profile").document(userId).collection("events")
        
        do {
            let snapshot = try await profileRef.getDocuments()
            let events = snapshot.documents.compactMap { try? $0.data(as: Event.self) }
            print("Events erfolgreich abgerufen.")
            self.selectedEvents = events
        } catch {
            print("Fehler beim Abrufen der Events: \(error.localizedDescription)")
        }
    }
    
    // Hinzufügen eines Events zu den ausgewählten Events
    func addToSelectedtEvents(_ event: Event) {
        if !selectedEvents.contains(event) {
            selectedEvents.append(event)
        }
    }
    
    func removeFromSelectedEvents(_ event: Event) {
        if let index = selectedEvents.firstIndex(of: event) {
            selectedEvents.remove(at: index)
        }
    }
    
    // Hinzufügen einer Wette zum Wettschein
    func addBetsToSlip(_ event: Event) {
        if !selectedBetEvents.contains(event) {
            selectedBetEvents.append(event)
        }
    }
    
    func removeBetsFromSlip(_ event: Event) {
        if let index = selectedBetEvents.firstIndex(of: event) {
            selectedBetEvents.remove(at: index)
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
}
