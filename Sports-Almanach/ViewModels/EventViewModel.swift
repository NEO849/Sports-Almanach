//
//  EventViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

/// Für die Verwaltung und Speicherung von Events
@MainActor
class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedEvents: [Event] = []
    @Published var selectedBetEvents: [Event] = []
    
    /// Repository für API-Zugriffe und Firestore-Datenbankinstanz
    private let eventRepository = EventRepository()
    private let datab = Firestore.firestore()
    
    /// Initialisierung mit Laden der aktuellen Events
    init() {
        loadingEvents(for: .current)
        Task {
            await fetchUserEvents()
        }
    }
    
    /// Lädt Events für eine bestimmte Season
    func loadingEvents(for season: Season) {
        Task {
            await loadEvents(season: season)
        }
    }
    
    /// Lädt Events aus dem Repository (Standart Saison)
    func loadEvents(season: Season) async {
        isLoading = true
        
        do {
            // Events über Repository laden
            let events = try await eventRepository.fetchEvents(for: season)
            await MainActor.run {
                self.events = events
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("🔴 Event-Lade-Fehler: \(error)")
        }
    }
    
    /// Speichern von Events im Benutzerprofil
    func saveEventToUserProfile(_ event: Event) async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("🔴 Kein Benutzer eingeloggt")
            return
        }
        do {
            let eventData: [String: Any] = [
                "id": event.id,
                "name": event.name,
                "timestamp": Timestamp()
            ]
            try await Firestore.firestore()
                .collection("Profile")
                .document(userId)
                .collection("events")
                .document(event.id)
                .setData(eventData, merge: true)
            print("✅ Event erfolgreich im Profil gespeichert")
        } catch {
            print("🔴 Fehler beim Speichern des Events: \(error)")
        }
    }
    
    /// Entfernt ein Event aus der Benutzerauswahl
    /// Aktualisiert nur die UI, ohne die anderen Events zu beeinflussen
    func removeFromSelectedEvents(_ event: Event) {
        withAnimation {
            // Nur das spezifische Event aus der Liste entfernen
            selectedEvents.removeAll { $0.id == event.id }
            
            // Firestore-Update im Hintergrund
            Task {
                await deleteEventFromUserProfile(eventId: event.id)
            }
        }
    }
    
    /// Löscht ein Event aus dem Benutzerprofil in Firestore
    private func deleteEventFromUserProfile(eventId: String) async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("🔴 Benutzer-ID nicht gefunden")
            return
        }
        
        do {
            let eventRef = datab.collection("Profile")
                .document(userId)
                .collection("events")
                .document(eventId)
            
            try await eventRef.delete()
            print("✅ Event \(eventId) erfolgreich gelöscht")
        } catch {
            print("🔴 Fehler beim Löschen des Events: \(error)")
        }
    }
    
    /// Lädt alle gespeicherten Events des Benutzers
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
    
    /// Fügt ein Event zur Auswahl hinzu
    func addToSelectedEvents(_ event: Event) {
        if !selectedEvents.contains(event) {
            selectedEvents.append(event)
            Task {
                await saveEventToUserProfile(event)
            }
        }
    }
    
    /// Event für Wetten auswählen
    func addToBet(_ event: Event) {
        if !selectedBetEvents.contains(event) {
            selectedBetEvents.append(event)
        }
    }
    
    /// Event aus der Wettliste entfernen
    func removeFromBet(_ event: Event) {
        selectedBetEvents.removeAll { $0.id == event.id }
    }
    
    /// Alle gewetteten Events entfernen
    func clearSelectedEvents() {
        selectedBetEvents.removeAll()
    }
    
    // MARK: - Hilfsmethoden aus SportEventUtils
    func formattedDate(for event: Event) -> String {
        SportEventUtils.formattedDate(for: event)
    }
    func formattedTime(for event: Event) -> String {
        SportEventUtils.formattedTime(for: event)
    }
}
