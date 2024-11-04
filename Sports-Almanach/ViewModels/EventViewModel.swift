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
    @Published var selectedBetEvents: [Event] = []
    @Published var selectedEvents: [Event] = [] {
        didSet {
            print("selectedEvents wurde aktualisiert: \(selectedEvents)")
            saveUserSelectedEvents() /// Speichert Events bei jeder Änderung
        }
    }
    private let eventRepository = EventRepository()
    private let datab = Firestore.firestore()
    
    init() {
        loadingEvents(for: .current)
        loadUserSelectedEvents()
    }
    
    /// Lädt die Events für die angegebene Saison asynchron
    func loadingEvents(for season: Season) {
        Task {
            await loadEvents(for: season)
        }
    }
    
    // Abrufen der Events aus dem Repo
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
                print("Geladene Events im ViewModel: \(fetchedEvents)")
                // Nach dem Laden, die ausgewählten Events aktual.
                                self.loadUserSelectedEvents()
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
    
    /// Speichert die ausgewählten Events-IDs im Nutzerprofil in Firestore
    func saveUserSelectedEvents() {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        
        let selectedEventIds = selectedEvents.map { $0.id } // IDs
        datab.collection("Profile").document(userId).updateData(["selectedEventsId": selectedEventIds]) { error in
            if let error = error {
                print("Fehler beim Speichern der ausgewählten Events: \(error.localizedDescription)")
            } else {
                print("Ausgewählte Events erfolgreich gespeichert.")
            }
        }
    }
    
    /// Lädt sie aus dem Nutzerprofil in Firestore
    func loadUserSelectedEvents() {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        print("Benutzer-ID: \(userId)") // Benutzer Id korrekt?
        datab.collection("Profile").document(userId).getDocument { document, error in
              if let error = error {
                  print("Fehler beim Laden der ausgewählten Events: \(error.localizedDescription)")
                  return
              }
              
              if let document = document, document.exists {
                  if let data = document.data(), let selectedEventIds = data["selectedEventsId"] as? [String] {
                      // Events anhand der gespeicherten IDs aus den geladenen Events filtern
                      self.selectedEvents = self.events.filter { selectedEventIds.contains($0.id) }
                      print("Ausgewählte Events erfolgreich geladen.")
                  } else {
                      print("Keine ausgewählten Event-IDs gefunden.")
                  }
              } else {
                  // Dokument existiert nicht, neues Dokument erstellen
                  print("Dokument existiert nicht.")
              }
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
