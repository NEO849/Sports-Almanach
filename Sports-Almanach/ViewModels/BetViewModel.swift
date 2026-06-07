//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Bet composition + history.
//
//  Differences vs the legacy implementation:
//
//  - `placeBets` is now `async throws` end-to-end. The legacy sync wrapper
//    `syncPlaceBets` that always returned `true` (even on failure!) is gone.
//  - Stake is `Money`, not `Double`.
//  - Settlement happens via `BettingService.settlePendingSlips(...)`. A view
//    can call `refreshHistory()` to drive both load and settlement.
//

import Foundation
import SwiftUI

@MainActor
public final class BetViewModel: ObservableObject {

    @Published public private(set) var draftBets: [Bet] = []
    @Published public private(set) var stake: Money = .zero
    @Published public private(set) var loadedSlips: [BetSlip] = []
    @Published public private(set) var isPlacing: Bool = false
    @Published public private(set) var lastError: String?

    public var totalOdds: Decimal {
        draftBets.reduce(Decimal(1)) { $0 * $1.odds }
    }

    public var potentialWin: Money {
        (stake * totalOdds).rounded()
    }

    private let bettingService: BettingService
    private let betRepository: BetRepositoryProtocol
    private let eventRepository: EventRepositoryProtocol
    private let session: AppSession

    public init(session: AppSession,
                bettingService: BettingService = AppContainer.shared.bettingService(),
                betRepository: BetRepositoryProtocol = AppContainer.shared.betRepository(),
                eventRepository: EventRepositoryProtocol = AppContainer.shared.eventRepository()) {
        self.session = session
        self.bettingService = bettingService
        self.betRepository = betRepository
        self.eventRepository = eventRepository
    }

    // MARK: - Draft management

    public func setStake(_ amount: Money) {
        // The slider may report 0; clamp the floor so we don't violate the
        // service-side minimum stake check silently.
        stake = max(amount, .zero)
    }

    public func addDraftBet(_ bet: Bet) {
        guard !draftBets.contains(where: { $0.event.eventID == bet.event.eventID }) else { return }
        draftBets.append(bet)
    }

    public func removeDraftBet(at offset: IndexSet) {
        draftBets.remove(atOffsets: offset)
    }

    public func removeDraftBet(eventID: String) {
        draftBets.removeAll { $0.event.eventID == eventID }
    }

    public func clearDraft() {
        draftBets.removeAll()
        stake = .zero
    }

    // MARK: - Place

    public func placeSlip() async -> Bool {
        guard let user = session.currentUser else {
            lastError = AppErrors.Auth.notAuthenticated.errorDescription
            return false
        }
        isPlacing = true
        defer { isPlacing = false }
        do {
            _ = try await bettingService.placeSlip(stake: stake, bets: draftBets, for: user)
            clearDraft()
            await refreshHistory()
            return true
        } catch {
            lastError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            return false
        }
    }

    // MARK: - History + settlement

    public func refreshHistory() async {
        guard let userID = session.currentUser?.id else { return }

        // Settlement is best-effort and must NEVER block loading the history —
        // otherwise a single settle failure hides the user's whole slip list.
        do {
            try await bettingService.settlePendingSlips(forUser: userID) { [eventRepository] eventID in
                try await eventRepository.fetchEvent(id: eventID)
            }
        } catch {
            AppLogger.error("Settlement failed (continuing to load history): \(error.localizedDescription)", category: .betting)
        }

        do {
            loadedSlips = try await betRepository.loadSlips(userID: userID)
        } catch {
            AppLogger.error("Loading slip history failed: \(error.localizedDescription)", category: .betting)
        }
    }

    // MARK: - Lifecycle from AppSession

    public func didAuthenticate(_ user: SportsAlmanachUser) async {
        await refreshHistory()
    }

    public func didSignOut() {
        draftBets = []
        stake = .zero
        loadedSlips = []
        lastError = nil
    }

    public func clearError() {
        lastError = nil
    }
}

#if DEBUG
extension BetViewModel {
    /// Pre-seeded ViewModel for Canvas previews (draft slip + history).
    static func preview(session: AppSession,
                        draft: [Bet] = Array(Mocks.bets.prefix(2)),
                        history: [BetSlip] = Mocks.betSlips,
                        stake: Money = Money(10)) -> BetViewModel {
        let vm = BetViewModel(
            session: session,
            bettingService: PreviewServices.bettingService(),
            betRepository: PreviewBetRepository(),
            eventRepository: PreviewEventRepository()
        )
        vm.draftBets = draft
        vm.loadedSlips = history
        vm.setStake(stake)
        return vm
    }
}
#endif
