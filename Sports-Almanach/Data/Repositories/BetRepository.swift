//
//  Untitled.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.02.25.
//
import Foundation
import FirebaseFirestore

/// Repository für die Verwaltung von Wetten und Wettscheinen
class BetRepository {
    
    // MARK: - Properties
    private let datab = Firestore.firestore()
    private let eventRepo = EventRepository()
    
    // MARK: - Logging
    private func logError(_ error: Error, context: String) {
        #if DEBUG
        print("🔴 \(context): \(error.localizedDescription)")
        #endif
    }
    
    private func logSuccess(_ message: String) {
        #if DEBUG
        print("✅ \(message)")
        #endif
    }
    
    private func logInfo(_ message: String) {
        #if DEBUG
        print("ℹ\u{fef} \(message)")
        #endif
    }
    
    // MARK: - BetSlip Management
    
    /// Speichert einen neuen Wettschein
    /// - Parameters:
    ///   - betSlip: Der zu speichernde Wettschein
    ///   - userId: ID des Benutzers
    @discardableResult
    func saveBetSlip(_ betSlip: BetSlip, userId: String) async throws -> Bool {
        do {
            // Wettschein-Daten
            let betSlipData: [String: Any] = [
                "userId": userId,
                "slipNumber": betSlip.slipNumber,
                "createdAt": Timestamp(date: betSlip.createdAt),
                "isWon": betSlip.isWon,
                "totalStake": betSlip.totalStake,
                "totalOdds": betSlip.totalOdds
            ]
            
            // Wettschein speichern
            let slipRef = try await datab.collection("BetSlips").addDocument(data: betSlipData)
            
            // Einzelne Wetten als Subcollection speichern
            for bet in betSlip.bets {
                let betData: [String: Any] = [
                    "eventId": bet.event.id,
                    "userTip": bet.userTip.rawValue,
                    "odds": bet.odds,
                    "betAmount": bet.betAmount,
                    "timestamp": Timestamp(date: bet.timestamp)
                ]
                
                try await slipRef.collection("bets").addDocument(data: betData)
            }
            
            logSuccess("Wettschein \(betSlip.slipNumber) gespeichert")
            return true
        } catch {
            logError(error, context: "Wettschein speichern")
            throw error
        }
    }
    
    /// Lädt alle Wettscheine eines Benutzers, nach Nummer sortiert
    func loadBetSlips(userId: String) async throws -> [BetSlip] {
        do {
            let snapshot = try await datab.collection("BetSlips")
                .whereField("userId", isEqualTo: userId)
                .order(by: "slipNumber", descending: true)
                .getDocuments()
            
            // Wettscheine mit Wetten laden
            var betSlips: [BetSlip] = []
            for document in snapshot.documents {
                let data = document.data()
                
                guard let slipNumber = data["slipNumber"] as? Int,
                      let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
                      let isWon = data["isWon"] as? Bool else {
                    logError(AppErrors.Api.decodingFailed, context: "BetSlip Dekodierung")
                    continue
                }
                
                // Zugehörige Wetten laden
                let betsSnapshot = try await document.reference
                    .collection("bets").getDocuments()
                
                var bets: [Bet] = []
                for betDoc in betsSnapshot.documents {
                    if let bet = try? await loadBet(from: betDoc) {
                        bets.append(bet)
                    }
                }
                
                // Wettschein erstellen
                let betSlip = BetSlip(
                    userId: userId,
                    slipNumber: slipNumber,
                    bets: bets,
                    createdAt: createdAt,
                    isWon: isWon
                )
                
                betSlips.append(betSlip)
            }
            
            logSuccess("\(betSlips.count) Wettscheine geladen")
            return betSlips
            
        } catch {
            logError(error, context: "Wettscheine laden")
            throw error
        }
    }
    
    // MARK: - Private Helper
    
    /// Lädt eine einzelne Wette aus einem Firestore-Dokument
    private func loadBet(from document: DocumentSnapshot) async throws -> Bet {
        let data = document.data() ?? [:]
        
        guard let eventId = data["eventId"] as? String,
              let userPickRaw = data["userTip"] as? Int,
              let userTip = UserTip(rawValue: userPickRaw),
              let odds = data["odds"] as? Double,
              let betAmount = data["betAmount"] as? Double,
              let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
            throw AppErrors.Api.decodingFailed
        }
        
        // Zugehöriges Event laden
        let event = try await loadEvent(withId: eventId)
        
        return Bet(
            event: event,
            userTip: userTip,
            odds: odds,
            betAmount: betAmount,
            timestamp: timestamp,
            betSlipNumber: 0 // wird vom BetSlip gesetzt
        )
    }
    
    /// Lädt ein Event aus dem EventRepository
    private func loadEvent(withId eventId: String) async throws -> Event {
        do {
            let events = try await eventRepo.fetchEvents(for: .current)
            guard let event = events.first(where: { $0.id == eventId }) else {
                throw AppErrors.Api.decodingFailed
            }
            return event
        } catch {
            logError(error, context: "Event laden")
            throw error
        }
    }
}
