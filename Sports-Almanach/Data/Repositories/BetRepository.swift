//
//  BetRepository.swift
//  Sports-Almanach
//
//  Firestore-backed BetRepository.
//
//  Two structural changes vs the legacy implementation:
//
//  1. **No N+1 fetch.** The legacy `loadBet(...)` called `eventRepo.fetchEvents`
//     for *every single historical bet*, refetching the entire season each
//     time. Bets now embed an `EventSnapshot` so history renders without any
//     follow-up network calls.
//
//  2. **Atomic placement.** `placeSlip(_:debiting:from:)` uses a Firestore
//     transaction so the stake debit and the slip creation either both happen
//     or neither does. The legacy code debited the balance up front in a
//     fire-and-forget Task and then attempted to save the slip — a single
//     network failure left the user's balance debited with no slip stored.
//

import Foundation
import FirebaseFirestore

public final class BetRepository: BetRepositoryProtocol, @unchecked Sendable {

    private let firestore: Firestore

    /// Kept for the Phase-3 transition layer; future commits remove it.
    private let eventRepository: EventRepositoryProtocol

    public init(firestore: Firestore = .firestore(),
                eventRepository: EventRepositoryProtocol) {
        self.firestore = firestore
        self.eventRepository = eventRepository
    }

    // MARK: - Place

    public func placeSlip(_ slip: BetSlip, debiting stake: Money, from userID: String) async throws {
        AppLogger.info("Attempting to place slip #\(slip.slipNumber) for user \(userID), stake: \(stake.formatted())", category: .betting)
        
        let slipRef = slipsCollection.document(slip.id.uuidString)
        let profileRef = firestore
            .collection(AppConstants.FirestoreCollections.profiles)
            .document(userID)

        // Pre-encode payloads on the calling actor; the transaction block
        // executes on Firestore's internal queue and shouldn't do encoding work.
        let slipPayload = try Self.encode(slip: slip)
        let betPayloads: [(String, [String: Any])] = try slip.bets.map { bet in
            (bet.id.uuidString, try Self.encode(bet: bet))
        }

        do {
            try await firestore.runTransaction({ transaction, errorPointer -> Any? in
                let profileSnap: DocumentSnapshot
                do {
                    profileSnap = try transaction.getDocument(profileRef)
                } catch let fetchError as NSError {
                    AppLogger.error("Failed to fetch profile during transaction: \(fetchError.localizedDescription)", category: .betting)
                    errorPointer?.pointee = fetchError
                    return nil
                }

                guard let profileData = profileSnap.data() else {
                    AppLogger.error("Profile document exists but has no data for user \(userID)", category: .betting)
                    errorPointer?.pointee = AppErrors.Bet.balanceUnreadable as NSError
                    return nil
                }

                guard let balanceData = profileData["balance"] as? [String: Any] else {
                    AppLogger.error("Balance field missing or wrong type in profile for user \(userID)", category: .betting)
                    errorPointer?.pointee = AppErrors.Bet.balanceUnreadable as NSError
                    return nil
                }

                guard let currentBalance: Money = Self.decode(balanceData: balanceData) else {
                    AppLogger.error("Could not decode balance data for user \(userID)", category: .betting)
                    errorPointer?.pointee = AppErrors.Bet.balanceUnreadable as NSError
                    return nil
                }

                AppLogger.info("Current balance for user \(userID): \(currentBalance.formatted()), stake: \(stake.formatted())", category: .betting)

                guard currentBalance >= stake else {
                    AppLogger.warning("Insufficient funds for user \(userID): has \(currentBalance.formatted()), needs \(stake.formatted())", category: .betting)
                    errorPointer?.pointee = AppErrors.Bet.insufficientFunds as NSError
                    return nil
                }

                let newBalance = currentBalance - stake
                let encodedBalance: [String: Any]
                do {
                    encodedBalance = try Self.encodeBalance(newBalance)
                } catch {
                    AppLogger.error("Failed to encode new balance: \(error.localizedDescription)", category: .betting)
                    errorPointer?.pointee = error as NSError
                    return nil
                }
                transaction.updateData(["balance": encodedBalance], forDocument: profileRef)

                transaction.setData(slipPayload, forDocument: slipRef)
                for (betID, payload) in betPayloads {
                    let betRef = slipRef
                        .collection(AppConstants.FirestoreCollections.betSlipBetsSubcollection)
                        .document(betID)
                    transaction.setData(payload, forDocument: betRef)
                }
                return nil
            })

            AppLogger.info("Successfully placed slip #\(slip.slipNumber) for user \(userID)", category: .betting)
        } catch {
            AppLogger.error("Transaction failed for slip #\(slip.slipNumber): \(error.localizedDescription)", category: .betting)
            
            // Map Firestore permission errors to user-friendly messages
            let nsError = error as NSError
            if nsError.domain == "FIRFirestoreErrorDomain" && nsError.code == 7 {
                // Code 7 is permission denied
                throw AppErrors.Bet.permissionDenied
            }
            throw error
        }
    }

    // MARK: - Load

    public func loadSlips(userID: String) async throws -> [BetSlip] {
        try await loadSlips(userID: userID, statusFilter: nil)
    }

    public func loadPendingSlips(userID: String) async throws -> [BetSlip] {
        try await loadSlips(userID: userID, statusFilter: .pending)
    }

    private func loadSlips(userID: String, statusFilter: BetSlipStatus?) async throws -> [BetSlip] {
        AppLogger.info("Loading slips for user \(userID), status filter: \(statusFilter?.rawValue ?? "none")", category: .betting)
        
        // Query without ordering to avoid index requirement
        // We only use equality filters which work with single-field indexes (auto-created)
        var query: Query = slipsCollection.whereField("userID", isEqualTo: userID)

        // Don't add status filter here if we want to avoid composite index
        // Instead, we'll filter client-side
        
        let snapshot = try await query.getDocuments()
        AppLogger.info("Fetched \(snapshot.documents.count) slip documents", category: .betting)

        var slips: [BetSlip] = []
        slips.reserveCapacity(snapshot.documents.count)

        for document in snapshot.documents {
            guard let slip = try Self.decode(slipDocument: document) else { 
                AppLogger.warning("Could not decode slip document \(document.documentID)", category: .betting)
                continue 
            }
            
            // Client-side status filtering to avoid composite index requirement
            if let statusFilter, slip.status != statusFilter {
                continue
            }
            
            let betsSnapshot = try await document.reference
                .collection(AppConstants.FirestoreCollections.betSlipBetsSubcollection)
                .getDocuments()
            let bets = betsSnapshot.documents.compactMap { try? Self.decode(betDocument: $0) }
            var hydrated = slip
            hydrated.bets = bets
            slips.append(hydrated)
        }
        
        // Client-side sorting by slipNumber (descending) to avoid composite index
        let sortedSlips = slips.sorted { $0.slipNumber > $1.slipNumber }
        AppLogger.info("Returning \(sortedSlips.count) slips after filtering and sorting", category: .betting)
        return sortedSlips
    }

    // MARK: - Settle

    public func settleSlip(_ slip: BetSlip, creditingTo userID: String) async throws {
        let slipRef = slipsCollection.document(slip.id.uuidString)
        let profileRef = firestore
            .collection(AppConstants.FirestoreCollections.profiles)
            .document(userID)

        let slipPayload = try Self.encode(slip: slip)
        let betPayloads: [(String, [String: Any])] = try slip.bets.map { bet in
            (bet.id.uuidString, try Self.encode(bet: bet))
        }
        let credit = slip.winAmount ?? .zero

        try await firestore.runTransaction({ transaction, errorPointer -> Any? in
            // 1) READS ZUERST. Firestore-Transaktionen verlangen, dass ALLE Reads
            //    vor ALLEN Writes passieren. Der bisherige Code las das Profil NACH
            //    den setData-Writes — das warf bei jedem Gewinn (credit > 0) und
            //    ließ den Slip "pending" stehen (Gewinn nie gutgeschrieben).
            var encodedNewBalance: [String: Any]? = nil
            if credit.isPositive {
                let profileSnap: DocumentSnapshot
                do {
                    profileSnap = try transaction.getDocument(profileRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard
                    let balanceData = profileSnap.data()?["balance"] as? [String: Any],
                    let currentBalance: Money = Self.decode(balanceData: balanceData)
                else {
                    errorPointer?.pointee = AppErrors.Bet.balanceUnreadable as NSError
                    return nil
                }
                do {
                    encodedNewBalance = try Self.encodeBalance(currentBalance + credit)
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
            }

            // 2) WRITES DANACH. Slip + Bets aktualisieren und – falls gewonnen –
            //    den Gewinn gutschreiben.
            transaction.setData(slipPayload, forDocument: slipRef, merge: true)
            for (betID, payload) in betPayloads {
                let betRef = slipRef
                    .collection(AppConstants.FirestoreCollections.betSlipBetsSubcollection)
                    .document(betID)
                transaction.setData(payload, forDocument: betRef, merge: true)
            }
            if let encodedNewBalance {
                transaction.updateData(["balance": encodedNewBalance], forDocument: profileRef)
            }
            return nil
        })
    }

    public func nextSlipNumber(forUser userID: String) async throws -> Int {
        let snapshot = try await slipsCollection
            .whereField("userID", isEqualTo: userID)
            .order(by: "slipNumber", descending: true)
            .limit(to: 1)
            .getDocuments()
        let last = snapshot.documents.first?.data()["slipNumber"] as? Int ?? 0
        return last + 1
    }

    private var slipsCollection: CollectionReference {
        firestore.collection(AppConstants.FirestoreCollections.betSlips)
    }

    // MARK: - Encoding helpers

    private static func encode(slip: BetSlip) throws -> [String: Any] {
        let encoder = Firestore.Encoder()
        var data = try encoder.encode(slip)
        data.removeValue(forKey: "bets") // bets stored as a sub-collection
        return data
    }

    private static func encode(bet: Bet) throws -> [String: Any] {
        try Firestore.Encoder().encode(bet)
    }

    private static func encodeBalance(_ money: Money) throws -> [String: Any] {
        try Firestore.Encoder().encode(money)
    }

    private static func decode(balanceData: [String: Any]) -> Money? {
        try? Firestore.Decoder().decode(Money.self, from: balanceData)
    }

    private static func decode(slipDocument: QueryDocumentSnapshot) throws -> BetSlip? {
        // Das Slip-Dokument speichert die Wetten als Subcollection — der 'bets'-
        // Schlüssel wird beim Schreiben entfernt. BetSlip.bets ist nicht-optional,
        // daher würde data(as:) hier mit keyNotFound("bets") scheitern und der
        // Slip würde verworfen -> KEIN Wettschein in der Historie und das
        // Settlement fände keine pending-Slips. Wir ergänzen einen leeren Default;
        // loadSlips hydratisiert die echten Wetten anschließend aus der Subcollection.
        var data = slipDocument.data()
        if data["bets"] == nil { data["bets"] = [[String: Any]]() }
        return try? Firestore.Decoder().decode(BetSlip.self, from: data)
    }

    private static func decode(betDocument: QueryDocumentSnapshot) throws -> Bet? {
        try? betDocument.data(as: Bet.self)
    }
}
