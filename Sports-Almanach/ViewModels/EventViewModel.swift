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
    private let dbase = Firestore.firestore()
    
    // Task cancellation
    private var loadingTask: Task<Void, Never>?
    
    /// Initialisierung mit Laden der aktuellen Events
    init() {
        loadingEvents(for: .defaultSeason)
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
        loadingTask = Task {
            do {
                if Task.isCancelled { return }
                // Events über Repository laden
                let events = try await eventRepository.fetchEvents(for: season)
                if Task.isCancelled { return }
                await MainActor.run {
                    self.events = events
                    self.isLoading = false
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                }
                print("🔴 Event-Lade-Fehler: \(error)")
            }
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
    
    /// Entfernt ein Event aus der Auswahl und aus Firestore
    func removeFromSelectedEvents(_ event: Event) async {
        // 1. Zuerst aus der lokalen Liste entfernen mit Animation
        withAnimation {
            selectedEvents.removeAll { $0.id == event.id }
        }
        
        // 2. Dann aus Firestore löschen
        await deleteEventFromUserProfile(eventId: event.id)
        
        print("✅ Event \(event.id) aus UI und Firestore entfernt")
    }
    
    /// Löscht ein Event aus dem Benutzerprofil in Firestore
    private func deleteEventFromUserProfile(eventId: String) async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("❌ Benutzer-ID nicht gefunden")
            return
        }
        do {
            let eventRef = dbase.collection("Profile")
                .document(userId)
                .collection("events")
                .document(eventId)
            
            try await eventRef.delete()
            print("✅ Event \(eventId) aus Firestore gelöscht")
        } catch {
            print("❌ Fehler beim Löschen des Events: \(error)")
        }
    }
    
    /// Lädt alle gespeicherten Events des Benutzers
    func fetchUserEvents() async {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        let profileRef = dbase.collection("Profile").document(userId).collection("events")
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
    
    /// Synchrone Wrapper-Funktion für das Event-Löschen
    func syncDeleteEvent(_ event: Event) {
        Task {
            await removeFromSelectedEvents(event)
        }
    }
    
    /// Methode um Tasks zu canceln
    func cancelLoadingTasks() {
        loadingTask?.cancel()
        loadingTask = nil
    }
    
    // MARK: - Hilfsmethoden aus SportEventUtils
    func formattedDate(for event: Event) -> String {
        SportEventUtils.formattedDate(for: event)
    }
    func formattedTime(for event: Event) -> String {
        SportEventUtils.formattedTime(for: event)
    }
}
