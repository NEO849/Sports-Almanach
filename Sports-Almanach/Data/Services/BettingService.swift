//
//  BettingService.swift
//  Sports-Almanach
//
//  Orchestrates bet placement and bet settlement.
//
//  Differences vs the legacy service:
//
//  - **Place is atomic.** Calls `BetRepositoryProtocol.placeSlip(...)` which
//    uses a Firestore transaction; the legacy code debited the balance
//    optimistically in a fire-and-forget Task before saving the slip,
//    creating a race where the user could lose money but have no record.
//
//  - **Settlement is its own step.** The legacy `evaluateBetSlip` mark-as-won
//    happened at placement time. For a not-yet-played match the score was
//    nil and the slip was instantly marked as lost. We now keep slips in
//    `.pending` and resolve them in batch when the app launches via
//    `settlePendingSlips(forUser:)`.
//
//  - **Decimal-precise math.** All odds and payouts go through `Money` and
//    `Decimal` so 1.10 + 1.10 + 1.10 == 3.30 (not 3.300000000004).
//

import Foundation

public final class BettingService: @unchecked Sendable {

    private let betRepository: BetRepositoryProtocol
    private let profileRepository: ProfileRepositoryProtocol

    public init(betRepository: BetRepositoryProtocol,
                profileRepository: ProfileRepositoryProtocol) {
        self.betRepository = betRepository
        self.profileRepository = profileRepository
    }

    // MARK: - Place

    /// Validates and persists a slip atomically with the stake debit.
    /// Throws `AppErrors.Bet.*` on validation failures so the caller can show
    /// a precise message — no more "true means did-nothing".
    public func placeSlip(stake: Money,
                          bets: [Bet],
                          for user: SportsAlmanachUser) async throws -> BetSlip {
        guard !bets.isEmpty else { throw AppErrors.Bet.noBetsOnSlip }
        guard stake >= AppConstants.Balances.minimumStake else { throw AppErrors.Bet.stakeBelowMinimum }

        let slipNumber = try await betRepository.nextSlipNumber(forUser: user.id)
        let slip = BetSlip(
            userID: user.id,
            slipNumber: slipNumber,
            bets: bets,
            stake: stake
        )

        try await betRepository.placeSlip(slip, debiting: stake, from: user.id)
        return slip
    }

    // MARK: - Settle

    /// Walks every pending slip for `userID`, looks up the current event score
    /// for each bet, and updates the slip via the repository if at least one
    /// bet has transitioned out of pending.
    public func settlePendingSlips(forUser userID: String,
                                   eventLookup: (String) async throws -> Event?) async throws {
        let pending = try await betRepository.loadPendingSlips(userID: userID)
        for var slip in pending {
            var changed = false
            var updatedBets: [Bet] = []
            updatedBets.reserveCapacity(slip.bets.count)
            for var bet in slip.bets {
                if bet.status != .pending {
                    updatedBets.append(bet)
                    continue
                }

                // 1) Resolve from the result captured at placement time (offline,
                //    deterministic). For a match that was already finished when the
                //    bet was placed this immediately yields won/lost.
                var resolved = Self.resolve(
                    tip: bet.userTip,
                    odds: bet.odds,
                    homeScore: bet.event.homeScore,
                    awayScore: bet.event.awayScore,
                    isFinished: bet.event.isFinished == true,
                    isVoided: false,
                    stake: slip.stake,
                    betCount: slip.bets.count
                )

                // 2) Still pending? The match may have finished AFTER placement —
                //    best-effort live refetch (silently skipped if API unavailable).
                if resolved.status == .pending, let event = try? await eventLookup(bet.event.eventID) {
                    resolved = Self.resolve(
                        tip: bet.userTip,
                        odds: bet.odds,
                        homeScore: event.homeScore,
                        awayScore: event.awayScore,
                        isFinished: event.status == .finished,
                        isVoided: event.status == .cancelled || event.status == .postponed,
                        stake: slip.stake,
                        betCount: slip.bets.count
                    )
                }

                if resolved.status != bet.status {
                    bet.status = resolved.status
                    bet.winAmount = resolved.winAmount
                    changed = true
                }
                updatedBets.append(bet)
            }

            slip.bets = updatedBets
            let newSlipStatus = slip.recomputedStatus()
            if newSlipStatus != slip.status {
                slip.status = newSlipStatus
                changed = true
            }

            // Combo win = product of all bet odds × stake, paid only when every bet won.
            if slip.status == .won {
                slip.winAmount = (slip.stake * slip.totalOdds).rounded()
            } else if slip.status == .partiallyWon {
                // Sum of per-bet payouts that materialised (won or void-refund).
                let total = slip.bets.reduce(Money.zero) { $0 + ($1.winAmount ?? .zero) }
                slip.winAmount = total
            }

            if changed && slip.status.isTerminal {
                try await betRepository.settleSlip(slip, creditingTo: userID)
                AppLogger.info("Settled slip #\(slip.slipNumber) for user \(userID) → \(slip.status.rawValue)", category: .betting)
            }
        }
    }

    // MARK: - Per-bet resolution

    /// Maps a final score back to the user's tip. Pure & source-agnostic: the
    /// score/flags come either from the bet's embedded snapshot or a live refetch.
    /// Stake is split evenly between bets — used for `.partiallyWon` payouts.
    private static func resolve(tip: AnyOutcome,
                                odds: Decimal,
                                homeScore: Int?,
                                awayScore: Int?,
                                isFinished: Bool,
                                isVoided: Bool,
                                stake: Money,
                                betCount: Int) -> (status: BetStatus, winAmount: Money?) {
        let perBet = stake * (1 / Decimal(betCount))

        if isVoided {
            return (.void, perBet.rounded())            // cancelled / postponed → refund
        }

        // A match with BOTH scores is decided — resolve on the score itself
        // rather than the free API's status string, which is frequently empty
        // or garbled and would otherwise leave a finished match stuck "pending".
        if let actual = MatchOutcome.from(homeScore: homeScore, awayScore: awayScore) {
            return tip.stableID == actual.stableID
                ? (.won, (perBet * odds).rounded())     // correct tip → payout
                : (.lost, nil)
        }

        // No score yet. If the status nonetheless says finished, treat as void
        // (no usable result); otherwise it's simply not played yet.
        return isFinished ? (.void, perBet.rounded()) : (.pending, nil)
    }
}
