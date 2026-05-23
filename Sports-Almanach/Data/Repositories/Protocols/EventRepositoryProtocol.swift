//
//  EventRepositoryProtocol.swift
//  Sports-Almanach
//
//  Abstract contract so ViewModels do not depend on Firestore or HTTP types.
//  Concrete impls live in Data/Repositories/, fakes live in test targets.
//

import Foundation

public protocol EventRepositoryProtocol: AnyObject, Sendable {
    /// Fetch events for the selected league & season. Bounded retry is the
    /// concrete implementation's responsibility.
    func fetchEvents(league: League, season: Season) async throws -> [Event]

    /// Look up a single event by its SportsDB id. Used by `BettingEvaluator`
    /// after a slip is settled, to refresh scores before re-evaluating.
    func fetchEvent(id eventID: String) async throws -> Event?

    /// Persist the user's selected events (for personalised home view) under
    /// `Profile/{uid}/events`.
    func persistSelectedEvent(_ event: Event, forUser userID: String) async throws
    func removeSelectedEvent(eventID: String, forUser userID: String) async throws
    func loadSelectedEvents(forUser userID: String) async throws -> [Event]
}
