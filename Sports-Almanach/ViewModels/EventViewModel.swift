//
//  EventViewModel.swift
//  Sports-Almanach
//
//  ViewModel for browsing events + persisting user selections.
//
//  Changes vs the legacy implementation:
//
//  - Calls now respect the league the UI picks (the legacy code only ever
//    fetched league id=4328).
//  - Repository is injected via the protocol — testable.
//  - All Firestore writes flow through EventRepository; the VM no longer
//    touches `Firestore.firestore()` directly.
//  - Task lifecycle uses `task(id:)` semantics — there's no manual
//    `cancelLoadingTasks()` to remember anymore.
//

import Foundation
import SwiftUI

@MainActor
public final class EventViewModel: ObservableObject {

    @Published public private(set) var events: [Event] = []
    @Published public private(set) var selectedEvents: [Event] = []
    @Published public private(set) var betCandidates: [Event] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?

    @Published public var selectedLeague: League = .default
    @Published public var selectedSeason: Season = .default
    @Published public var selectedSport: Sport = .defaultSport

    private let eventRepository: EventRepositoryProtocol
    private let session: AppSession

    public init(session: AppSession,
                eventRepository: EventRepositoryProtocol = AppContainer.shared.eventRepository()) {
        self.session = session
        self.eventRepository = eventRepository
    }

    // MARK: - Load

    public func reload() async {
        isLoading = true
        defer { isLoading = false }
        do {
            events = try await eventRepository.fetchEvents(league: selectedLeague, season: selectedSeason)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            AppLogger.error("Event reload failed: \(error)", category: .api)
        }
    }

    public func didAuthenticate(_ user: SportsAlmanachUser) async {
        await reload()
        await reloadSelectedEvents(userID: user.id)
    }

    public func didSignOut() {
        events = []
        selectedEvents = []
        betCandidates = []
        errorMessage = nil
    }

    public func reloadSelectedEvents(userID: String) async {
        do {
            selectedEvents = try await eventRepository.loadSelectedEvents(forUser: userID)
        } catch {
            AppLogger.warning("Selected events load failed: \(error.localizedDescription)", category: .repository)
        }
    }

    // MARK: - User selection

    public func addToSelection(_ event: Event) async {
        guard let userID = session.currentUser?.id else { return }
        if !selectedEvents.contains(where: { $0.id == event.id }) {
            selectedEvents.append(event)
        }
        do {
            try await eventRepository.persistSelectedEvent(event, forUser: userID)
        } catch {
            AppLogger.warning("persistSelectedEvent failed: \(error.localizedDescription)", category: .repository)
            // Roll back local change.
            selectedEvents.removeAll { $0.id == event.id }
        }
    }

    public func removeFromSelection(_ event: Event) async {
        guard let userID = session.currentUser?.id else { return }
        withAnimation { selectedEvents.removeAll { $0.id == event.id } }
        do {
            try await eventRepository.removeSelectedEvent(eventID: event.id, forUser: userID)
        } catch {
            AppLogger.warning("removeSelectedEvent failed: \(error.localizedDescription)", category: .repository)
            // Re-insert on failure.
            selectedEvents.append(event)
        }
    }

    // MARK: - Bet candidates
    /// Events the user has marked for the BetSlip composer (separate from
    /// "saved to profile"). Future-bets only — finished events are filtered out.
    public func addToBetCandidates(_ event: Event) {
        guard event.status != .finished else { return }
        if !betCandidates.contains(where: { $0.id == event.id }) {
            betCandidates.append(event)
        }
    }

    public func removeBetCandidate(_ event: Event) {
        betCandidates.removeAll { $0.id == event.id }
    }

    public func clearBetCandidates() {
        betCandidates.removeAll()
    }
}

#if DEBUG
extension EventViewModel {
    /// Pre-seeded ViewModel for Canvas previews (events + current selection).
    static func preview(session: AppSession,
                        events: [Event] = Mocks.events,
                        selected: [Event] = Array(Mocks.events.prefix(2))) -> EventViewModel {
        let vm = EventViewModel(session: session, eventRepository: PreviewEventRepository())
        vm.events = events
        vm.selectedEvents = selected
        return vm
    }
}
#endif
