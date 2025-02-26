//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation
import SwiftUI

/// Kümmert sich um die Kommunikation mit der API und die Datenverarbeitung
class EventRepository {
    
    private let useMockData = false // Umschalten
    
    func fetchEvents(for season: Season) async throws -> [Event] {
        if useMockData {
            return fetchMockEvents(for: season)
        } else {
            return try await fetchApiEvents(for: season)
        }
    }
    
    /// API-Call, Enpunkt in Enum
    private func fetchApiEvents(for season: Season) async throws -> [Event] {
        let urlString = "https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4328&s=\(season.rawValue)"
        
        /// url gültig?
        guard let url = URL(string: urlString) else {
            throw AppErrors.Api.invalidURL
        }
        print("URL-String: \(urlString)")
        
        /// Um die Daten A-Synchron abzurufen und in einen String umwandeln
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Fehlermanagement
//            print("------- Rohe Daten: \(data)")
//            if let dataString = String(data: data, encoding: .utf8) {
//                print("------- Daten empfangen: \(dataString)")
//            } else {
//                print("Fehler beim Konvertieren der Daten in einen String.")
//            }
            
            /// JSONDecoder konfigurieren
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            /// Um die Daten in ein EventResponse Objekt zu dekodieren, events zurückgeben
            let response = try decoder.decode(EventResponse.self, from: data)
            
            // Fehlermanagement:  Werte der Properties ausgeben
            // for event in response.events {
            //                print("------- Werte der Properties")
            //                print("Event: \(event.name)")
            //                print("  id: \(event.id)")
            //                print("  sport: \(event.sport)")
            //                print("  leagueName: \(event.leagueName)")
            //                print("  leagueImage: \(event.leagueImage)")
            //                print("  season: \(event.season)")
            //                print("  homeTeam: \(event.homeTeam)")
            //                print("  awayTeam: \(event.awayTeam)")
            //                print("  homeScore: \(event.homeScore ?? "0")") // Wenn nil
            //                print("  awayScore: \(event.awayScore ?? "0")")
            //                print("  videoURL: \(event.videoURL ?? "Kein Video")")
            //                print("  homeTeamBadge: \(event.homeTeamBadge ?? "Kein Heimteam Wappen")")
            //                print("  awayTeamBadge: \(event.awayTeamBadge ?? "Kein Auswärtsteam Wappen")")
            //                print("  statusString: \(event.statusString)")
            //            }
            
            return response.events
        } catch let decodingError as DecodingError {
            print("Fehler beim Dekodieren der Daten: \(decodingError.localizedDescription)")
            throw AppErrors.Api.decodingFailed
        } catch {
            print("Anfrage an den Server ist fehlgeschlagen: \(error.localizedDescription)")
            throw AppErrors.Api.requestFailed
        }
    }
    
    /// Mock-Daten, gefilterte Liste bassierend der season
    private func fetchMockEvents(for season: Season) -> [Event] {
        return MockEvents.events.filter { $0.season == season.rawValue }
    }
}
