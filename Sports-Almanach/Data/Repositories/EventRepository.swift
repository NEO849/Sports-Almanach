//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation
import SwiftUI

/// Verantwortlich für das Laden und Cachen von Event-Daten
class EventRepository {
    // MARK: - Properties
    private let useMockData = false
    private let logger = LoggerService.shared
    
    /// API-Konfiguration
    private enum API {
        static let maxTry = 3
        static let timeBetweenTrys = 2.0
        static let baseURL = "https://www.thesportsdb.com/api/v1/json/3"
    }
    
    /// Lädt Events für eine bestimmte Saison
    func fetchEvents(for season: Season) async throws -> [Event] {
        if useMockData {
            return fetchMockEvents(for: season)
        }
        
        // Mehrere Versuche mit steigender Wartezeit
        for increasingTrys in 1...API.maxTry {
            do {
                let events = try await loadEvents(for: season)
                logger.log("✅ Events geladen (Versuch \(increasingTrys))", level: .success)
                return events
            } catch {
                logger.log("❌ Ladefehler (Versuch \(increasingTrys))", level: .error)
                
                // Bei letztem Versuch: Fehler werfen
                if increasingTrys == API.maxTry {
                    throw AppErrors.Api.requestFailed
                }
                
                // Sonst: Warten vor nächstem Versuch
                let waitingTime = API.timeBetweenTrys * Double(increasingTrys)
                logger.log("⏰ Warte \(waitingTime) Sekunden...", level: .info)
                try? await Task.sleep(nanoseconds: UInt64(waitingTime * 1_000_000_000))
            }
        }
        throw AppErrors.Api.requestFailed
    }
    
    /// Führt den API-Call durch
    private func loadEvents(for season: Season) async throws -> [Event] {
        let urlString = "\(API.baseURL)/eventsseason.php?id=4328&s=\(season.rawValue)"
        
        guard let url = URL(string: urlString) else {
            logger.log("❌ Ungültige URL", level: .error)
            throw AppErrors.Api.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP Response prüfen
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw AppErrors.Api.invalidResponse
            }
            
            // JSON dekodieren
            let decoder = JSONDecoder()
            let eventResponse = try decoder.decode(EventResponse.self, from: data)
            return eventResponse.events
            
        } catch let decodingError as DecodingError {
            logger.log("❌ Dekodierungsfehler: \(decodingError)", level: .error)
            throw AppErrors.Api.decodingFailed
        } catch {
            logger.log("❌ API Fehler: \(error.localizedDescription)", level: .error)
            throw AppErrors.Api.requestFailed
        }
    }
    
    /// Liefert Test-Daten
    private func fetchMockEvents(for season: Season) -> [Event] {
        logger.log("📋 Verwende Mock-Daten", level: .debug)
        return MockEvents.events.filter { $0.season == season.rawValue }
    }
}
