//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation
import SwiftUI

/// Verantwortlich für, API-Kommunikation, Daten-Caching und Fehlerbehandlung
class EventRepository {
    
    /// Flag für Mock-Daten in der Entwicklung
    private let useMockData = false
    
    /// Lädt Events für eine bestimmte Saison, Implementiert einen Retry-Mechanismus für robuste API-Kommunikation
    func fetchEvents(for season: Season) async throws -> [Event] {
        if useMockData {
            return fetchMockEvents(for: season)
        } else {
            let maxRetries = 3
            var lastError: Error?
            
            // Retry-Mechanismus
            for attempt in 1...maxRetries {
                do {
                    let events = try await fetchApiEvents(for: season)
                    print("✅ Events erfolgreich geladen (Versuch \(attempt))")
                    return events
                } catch {
                    lastError = error
                    print("🔴 API-Fehler (Versuch \(attempt)/\(maxRetries)): \(error.localizedDescription)")
                    if attempt < maxRetries {
                        try? await Task.sleep(nanoseconds: UInt64(3_000_000_000))
                    }
                }
            }
            throw lastError ?? AppErrors.Api.requestFailed
        }
    }
    
    /// Führt den tatsächlichen API-Call durch
    /// - Parameter season: Gewünschte Saison
    /// - Returns: Array von Events
    /// - Throws: API oder Dekodierungsfehler
    private func fetchApiEvents(for season: Season) async throws -> [Event] {
        let urlString = "https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4328&s=\(season.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw AppErrors.Api.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            let response = try decoder.decode(EventResponse.self, from: data)
            return response.events
            
        } catch let decodingError as DecodingError {
            print("🔴 Dekodierungsfehler: \(decodingError.localizedDescription)")
            throw AppErrors.Api.decodingFailed
        } catch {
            print("🔴 API-Fehler: \(error.localizedDescription)")
            throw AppErrors.Api.requestFailed
        }
    }
    
    /// Liefert Mock-Daten für Entwicklung und Tests
    private func fetchMockEvents(for season: Season) -> [Event] {
        return MockEvents.events.filter { $0.season == season.rawValue }
    }
}
