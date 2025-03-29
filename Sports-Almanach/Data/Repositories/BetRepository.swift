//
//  Untitled.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.02.25.
//

import Foundation
import FirebaseFirestore

/// Verwaltung von Wetten und Wettscheinen in Firestore
class BetRepository {
    
    private let dbase = Firestore.firestore()
    private let eventRepo = EventRepository()
    
    // MARK: - BetSlip Management
    /// Speichert einen neuen Wettschein in Firestore
    @discardableResult
    func saveBetSlip(_ betSlip: BetSlip, userId: String) async throws -> Bool {
        do {
            // Definiert eine eindeutige Document ID
            let betSlipId = betSlip.id.uuidString
            let betSlipRef = dbase.collection("BetSlips").document(betSlipId)
            
            let betSlipData: [String: Any] = [
                "userId": userId,
                "slipNumber": betSlip.slipNumber,
                "createdAt": Timestamp(date: betSlip.createdAt),
                "isWon": betSlip.isWon,
                "betAmount": betSlip.betAmount,
                "winAmount": betSlip.winAmount as Any
            ]
            
            // Hauptdokument für Wettschein erstellen
            try await betSlipRef.setData(betSlipData)
            
            // Einzelwetten als Sub-Collection speichern
            for bet in betSlip.bets {
                let betId = bet.id.uuidString
                let betData: [String: Any] = [
                    "eventId": bet.event.id,
                    "userTip": bet.userTip.rawValue,
                    "odds": bet.odds,
                    "timestamp": Timestamp(date: bet.timestamp),
                    "isWon": bet.isWon,
                    "winAmount": bet.winAmount as Any
                ]
                try await betSlipRef.collection("bets").document(betId).setData(betData)
            }
            logSuccess("Wettschein \(betSlip.slipNumber) erfolgreich gespeichert")
            return true
            
        } catch {
            logError(error, context: "Fehler beim Speichern des Wettscheins")
            throw error
        }
    }
    
    /// Aktualisiert den Status einer Einzelwette
    func updateBetStatus(betSlipId: String, betId: String, isWon: Bool, winAmount: Double?) async throws {
        do {
            var updateData: [String: Any] = ["isWon": isWon]
            if let winAmount = winAmount {
                updateData["winAmount"] = winAmount
            }
            
            try await dbase.collection("BetSlips")
                .document(betSlipId)
                .collection("bets")
                .document(betId)
                .updateData(updateData)
                
            logSuccess("Wettstatus aktualisiert: \(isWon ? "Gewonnen" : "Verloren")")
        } catch {
            logError(error, context: "Fehler beim Aktualisieren des Wettstatus")
            throw error
        }
    }
    
    /// Aktualisiert den Gesamtstatus eines Wettscheins
    func updateBetSlipStatus(betSlipId: UUID, isWon: Bool, winAmount: Double?) async throws {
        do {
            var updateData: [String: Any] = ["isWon": isWon]
            if let winAmount = winAmount {
                updateData["winAmount"] = winAmount
            }
            try await dbase.collection("BetSlips")
                .document(betSlipId.uuidString)
                .updateData(updateData)
            logSuccess("Wettschein-Status aktualisiert: \(isWon ? "Gewonnen" : "Verloren")")
        } catch {
            logError(error, context: "Fehler beim Aktualisieren des Wettschein-Status")
            throw error
        }
    }
    
    /// Lädt alle Wettscheine eines Benutzers
    func loadBetSlips(userId: String) async throws -> [BetSlip] {
        do {
            let snapshot = try await dbase.collection("BetSlips")
                .whereField("userId", isEqualTo: userId)
                .order(by: "slipNumber", descending: true)
                .getDocuments()
            
            var betSlips: [BetSlip] = []
            
            for document in snapshot.documents {
                let data = document.data()
                
                guard let slipNumber = data["slipNumber"] as? Int,
                      let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
                      let isWon = data["isWon"] as? Bool,
                      let betAmount = data["betAmount"] as? Double else {
                    logError(AppErrors.Api.decodingFailed, context: "Fehler beim Dekodieren des Wettscheins")
                    continue
                }
                
                let winAmount = data["winAmount"] as? Double
                
                // Zugehörige Einzelwetten laden
                let betsSnapshot = try await document.reference.collection("bets").getDocuments()
                var bets: [Bet] = []
                
                for betDoc in betsSnapshot.documents {
                    if let bet = try? await loadBet(from: betDoc) {
                        bets.append(bet)
                    }
                }
                
                let betSlip = BetSlip(
                    userId: userId,
                    slipNumber: slipNumber,
                    bets: bets,
                    createdAt: createdAt,
                    isWon: isWon,
                    betAmount: betAmount,
                    winAmount: winAmount
                )
                betSlips.append(betSlip)
            }
            logSuccess("\(betSlips.count) Wettscheine geladen")
            return betSlips
        } catch {
            logError(error, context: "Fehler beim Laden der Wettscheine")
            throw error
        }
    }
    
    /// Lädt eine einzelne Wette aus einem Firestore-Dokument
    private func loadBet(from document: DocumentSnapshot) async throws -> Bet {
        let data = document.data() ?? [:]
        
        guard let eventId = data["eventId"] as? String,
              let userTipRaw = data["userTip"] as? Int,
              let userTip = UserTip(rawValue: userTipRaw),
              let odds = data["odds"] as? Double,
              let timestamp = (data["timestamp"] as? Timestamp)?.dateValue(),
              let isWon = data["isWon"] as? Bool else {
            throw AppErrors.Api.decodingFailed
        }
        
        let winAmount = data["winAmount"] as? Double
        
        // Zugehöriges Event laden
        let event = try await loadEvent(withId: eventId)
        
        return Bet(
            event: event,
            userTip: userTip,
            odds: odds,
            winAmount: winAmount,
            timestamp: timestamp,
            isWon: isWon
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
            logError(error, context: "Fehler beim Laden des Events")
            throw error
        }
    }
    
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
        print("ℹ️ \(message)")
        #endif
    }
}
