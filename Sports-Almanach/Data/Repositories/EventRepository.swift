//
//  EventRepository.swift
//  Sports-Almanach
//
//  Concrete EventRepository — fetches from thesportsdb.com and persists user-
//  selected events to Firestore.
//
//  Key changes vs the legacy file:
//
//  - The selected league is actually used. The legacy code hard-coded
//    `id=4328` and silently ignored the `League` enum the UI picked.
//  - Retry/backoff is delegated to `Retry.run` (Core/Concurrency/RetryPolicy)
//    so the loop is no longer copy-pasted with bugs.
//  - Mock-data toggle removed in favour of a `MockEventRepository` test double
//    (see Data/Repositories/Mocks/MockEventRepository.swift). Switching modes
//    is now a DI concern, not a hidden `private let useMockData = false`.
//

import Foundation
import FirebaseFirestore

public final class EventRepository: EventRepositoryProtocol, @unchecked Sendable {

    private let firestore: Firestore
    private let session: URLSession
    private let retryPolicy: RetryPolicy

    public init(firestore: Firestore = .firestore(),
                session: URLSession = .shared,
                retryPolicy: RetryPolicy = .default) {
        self.firestore = firestore
        self.session = session
        self.retryPolicy = retryPolicy
    }

    // MARK: - SportsDB API

    public func fetchEvents(league: League, season: Season) async throws -> [Event] {
        try await Retry.run(retryPolicy) { [self] in
            try await loadOnce(league: league, season: season)
        }
    }

    public func fetchEvent(id eventID: String) async throws -> Event? {
        let urlString = "\(AppConstants.API.sportsDBBase)/lookupevent.php?id=\(eventID)"
        guard let url = URL(string: urlString) else { throw AppErrors.Api.invalidURL }
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        struct LookupResponse: Decodable { let events: [Event]? }
        let decoded = try JSONDecoder().decode(LookupResponse.self, from: data)
        return decoded.events?.first
    }

    private func loadOnce(league: League, season: Season) async throws -> [Event] {
        let urlString = "\(AppConstants.API.sportsDBBase)/eventsseason.php?id=\(league.sportsDBLeagueID)&s=\(season.rawValue)"
        guard let url = URL(string: urlString) else { throw AppErrors.Api.invalidURL }

        var request = URLRequest(url: url)
        request.timeoutInterval = AppConstants.API.requestTimeoutSeconds

        let (data, response) = try await session.data(for: request)
        try Self.validate(response)

        do {
            return try JSONDecoder().decode(EventResponse.self, from: data).events ?? []
        } catch {
            AppLogger.error("Decoding failed: \(error)", category: .api)
            throw AppErrors.Api.decodingFailed
        }
    }

    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw AppErrors.Api.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw AppErrors.Api.httpError(code: http.statusCode)
        }
    }

    // MARK: - User-event persistence (Firestore)

    public func persistSelectedEvent(_ event: Event, forUser userID: String) async throws {
        try await userEventsCollection(for: userID)
            .document(event.id)
            .setData(from: event, merge: true)
    }

    public func removeSelectedEvent(eventID: String, forUser userID: String) async throws {
        try await userEventsCollection(for: userID).document(eventID).delete()
    }

    public func loadSelectedEvents(forUser userID: String) async throws -> [Event] {
        let snapshot = try await userEventsCollection(for: userID).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Event.self) }
    }

    private func userEventsCollection(for userID: String) -> CollectionReference {
        firestore.collection(AppConstants.FirestoreCollections.profiles)
            .document(userID)
            .collection(AppConstants.FirestoreCollections.userEventsSubcollection)
    }
}

/// Top-level SportsDB response — events array may be null when a season has no fixtures.
public struct EventResponse: Decodable {
    public let events: [Event]?
}
