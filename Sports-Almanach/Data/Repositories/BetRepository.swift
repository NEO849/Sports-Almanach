//
//  Untitled.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.02.25.
//
import Foundation
import FirebaseFirestore

class BetRepository {
    
    // MARK: - Properties
    private let datab = Firestore.firestore()
    
    // MARK: - Score Processing
    
    /// Konvertiert die String-Scores in Integer und ermittelt das numerische Ergebnis
    /// - Parameter event: Das Event mit den Scores
    /// - Returns: Int (1 für Heimsieg, 0 für Unentschieden, 2 für Auswärtssieg)
    /// - Throws: AppErrors.Api.decodingFailed wenn Konvertierung fehlschlägt
    func getNumericResult(for event: Event) throws -> Int {
        // Konvertiere String-Scores in Integer
        guard let homeScoreStr = event.homeScore,
              let awayScoreStr = event.awayScore,
              let homeGoals = Int(homeScoreStr),
              let awayGoals = Int(awayScoreStr) else {
            throw AppErrors.Api.decodingFailed
        }
        
        print("Event: \(event.name) - Ergebnis: \(homeGoals):\(awayGoals)")
        
        // Numerisches Ergebnis ermitteln:
        // 1 = Heimsieg
        // 0 = Unentschieden
        // 2 = Auswärtssieg
        if homeGoals > awayGoals {
            print("Heimsieg (1)")
            return 1
        } else if homeGoals < awayGoals {
            print("Auswärtssieg (2)")
            return 2
        } else {
            print("Unentschieden (0)")
            return 0
        }
    }
    
    /// Konvertiert BetOutcome in numerischen Wert für Vergleich
    /// - Parameter outcome: Die Wette des Users
    /// - Returns: Int (1 für Heimsieg, 0 für Unentschieden, 2 für Auswärtssieg)
    func getNumericBet(for outcome: BetOutcome) -> Int {
        let result = switch outcome {
        case .homeWin: 1
        case .draw: 0
        case .awayWin: 2
        }
        print("User Tipp: \(outcome.titleGerman) (\(result))")
        return result
    }
    
    /// Speichert eine neue Wette in Firestore
    /// - Parameters:
    ///   - bet: Die zu speichernde Wette
    ///   - userId: ID des Benutzers
    /// - Returns: Bool ob das Speichern erfolgreich war
    @discardableResult
    func saveBet(_ bet: Bet, userId: String) async throws -> Bool {
        let betData: [String: Any] = [
            "userId": userId,
            "eventId": bet.event.id,
            "betAmount": bet.betAmount,
            "outcome": bet.outcome.rawValue, // Speichere direkt als Int
            "odds": bet.odds,
            "winAmount": bet.winAmount ?? 0.0,
            "betSlipNumber": bet.betSlipNumber,
            "timestamp": Timestamp(date: bet.timestamp)
        ]
        
        do {
            _ = try await datab.collection("Bets").addDocument(data: betData)
            print("Wette \(bet.betSlipNumber) erfolgreich gespeichert")
            return true
        } catch {
            print("Fehler beim Speichern der Wette: \(error)")
            throw AppErrors.Api.requestFailed
        }
    }
    
    // MARK: - Event Loading
    
    /// Lädt ein Event basierend auf der ID
    private func loadEvent(withId eventId: String) async throws -> Event {
        // Firestore Dokument laden
        let snapshot = try await datab.collection("Events")
            .whereField("id", isEqualTo: eventId)
            .getDocuments()
        
        // Dokument validieren
        guard let document = snapshot.documents.first else {
            throw AppErrors.Api.decodingFailed
        }
        
        // Daten extrahieren und validieren
        let data = document.data()
        guard let name = data["name"] as? String,
              let homeTeam = data["homeTeam"] as? String,
              let awayTeam = data["awayTeam"] as? String,
              let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
              let sportRaw = data["sport"] as? String,
              let leagueName = data["leagueName"] as? String,
              let seasonRaw = data["season"] as? String,
              let stadion = data["stadion"] as? String else {
            throw AppErrors.Api.decodingFailed
        }
        
        // Datum und Zeit formatieren
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: startDate)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: startDate)
        
        // Event erstellen und zurückgeben
        return Event(
            id: eventId,
            name: name,
            sport: sportRaw, // Nutze den Raw-String
            leagueName: leagueName,
            leagueImage: data["leagueImage"] as? String ?? "",
            season: seasonRaw, // Nutze den Raw-String
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            date: date,
            time: time,
            stadion: stadion,
            image: data["image"] as? String ?? "",
            videoURL: data["videoURL"] as? String,
            homeTeamBadge: data["homeTeamBadge"] as? String,
            awayTeamBadge: data["awayTeamBadge"] as? String,
            statusString: data["statusString"] as? String ?? "",
            homeScore: data["homeScore"] as? String,
            awayScore: data["awayScore"] as? String
        )
    }

    /// Lädt alle Wetten eines Benutzers
    func loadUserBets(userId: String) async throws -> [Bet] {
        let snapshot = try await datab.collection("Bets")
            .whereField("userId", isEqualTo: userId)
            .order(by: "betSlipNumber", descending: true)
            .getDocuments()
        
        // TaskGroup mit nicht-optionalem Bet-Typ
        return try await withThrowingTaskGroup(of: Bet.self) { group in
            for document in snapshot.documents {
                group.addTask {
                    let data = document.data()
                    
                    // Extrahiere Wettdaten mit Error Handling
                    guard let eventId = data["eventId"] as? String,
                          let betAmount = data["betAmount"] as? Double,
                          let outcomeRaw = data["outcome"] as? Int, // Direkt als Int lesen
                          let odds = data["odds"] as? Double,
                          let betSlipNumber = data["betSlipNumber"] as? Int,
                          let timestamp = (data["timestamp"] as? Timestamp)?.dateValue(),
                          let outcome = BetOutcome(rawValue: outcomeRaw) else { // Verwende den Int direkt
                        throw AppErrors.Api.decodingFailed
                    }
                    
                    // Event laden
                    let event = try await self.loadEvent(withId: eventId)
                    
                    // Bet erstellen mit korrekter Parameter-Reihenfolge
                    return Bet(
                        id: UUID(), // UUID generieren
                        event: event,
                        outcome: outcome,
                        odds: odds,
                        betAmount: betAmount,
                        winAmount: data["winAmount"] as? Double,
                        timestamp: timestamp,
                        betSlipNumber: betSlipNumber
                    )
                }
            }
            
            // Ergebnisse sammeln
            var bets = [Bet]()
            for try await bet in group {
                bets.append(bet)
            }
            return bets.sorted(by: { $0.betSlipNumber > $1.betSlipNumber })
        }
    }

    /// Aktualisiert den Kontostand eines Users
    /// - Parameters:
    ///   - userId: ID des Users
    ///   - newBalance: Neuer Kontostand
    func updateUserBalance(userId: String, newBalance: Double) async throws {
        try await datab.collection("Users").document(userId).updateData([
            "balance": newBalance
        ])
    }
    
    /// Markiert eine Wette als gewonnen oder verloren
    /// - Parameters:
    ///   - betId: ID der Wette
    ///   - won: Gewonnen oder verloren
    ///   - winAmount: Gewonnener Betrag
    func updateBetResult(betId: String, won: Bool, winAmount: Double?) async throws {
        try await datab.collection("Bets").document(betId).updateData([
            "won": won,
            "winAmount": winAmount ?? 0
        ])
    }
    
    /// Verarbeitet einen kompletten Wettschein
    /// - Parameters:
    ///   - bets: Array von Wetten, sortiert nach betSlipNumber
    ///   - events: Events mit aktuellen Ergebnissen
    ///   - currentBalance: Aktueller Kontostand
    /// - Returns: (Gewonnen/Verloren, Neuer Kontostand)
    func processWagerSlip(bets: [Bet], events: [Event], currentBalance: Double) throws -> (won: Bool, newBalance: Double) {
        // Gruppiere Wetten nach betSlipNumber
        let betSlips = Dictionary(grouping: bets, by: { $0.betSlipNumber })
        
        for (_, slipBets) in betSlips {
            var allCorrect = true
            var totalOdds = 1.0
            var betAmount = 0.0
            
            // Prüfe alle Wetten im Schein
            for bet in slipBets {
                guard let event = events.first(where: { $0.id == bet.event.id }) else {
                    continue
                }
                
                let actualResult = try getNumericResult(for: event)
                let userBet = getNumericBet(for: bet.outcome)
                
                if actualResult != userBet {
                    allCorrect = false
                    break
                }
                
                totalOdds *= bet.odds
                betAmount = bet.betAmount // Alle Wetten im Schein haben den gleichen Einsatz
            }
            
            // Wenn alle Wetten richtig sind, berechne den Gewinn
            if allCorrect {
                let winAmount = betAmount * totalOdds
                return (true, currentBalance + winAmount)
            }
        }
        
        return (false, currentBalance)
    }
}
