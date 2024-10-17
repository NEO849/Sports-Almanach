//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation
import SwiftUI

/// Kümmert sich um die Kommunikation mit der API und die Datenverarbeitung.
class EventRepository {
    
    func fetchEvents(for season: Season) async throws -> [Event] {
        // URL für den API-Call, inkl. der Season
        let urlString = "https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4328&s=\(season.rawValue)"
        
        // URL aus dem String
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
        
        do {
            // Daten von der API abrufen
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Daten empfangen: \(dataString)")
            } else {
                print("Fehler beim Konvertieren der Daten in einen String.")
            }
            
            // Daten in ein EventResponse-Objekt dekodieren
            let response = try JSONDecoder().decode(EventResponse.self, from: data)
            
            // Liste der Events zurückgeben
            return response.events
        } catch {
            print("Fehler beim Abrufen der API, der Events: \(error.localizedDescription)")
            throw ApiError.requestFailed
        }
    }
}
