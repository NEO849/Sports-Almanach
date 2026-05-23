//
//  BetSlipTests.swift
//  Sports-AlmanachTests
//

import XCTest
@testable import Sports_Almanach

final class BetSlipTests: XCTestCase {

    private func makeBet(odds: Decimal = 2, status: BetStatus = .pending) -> Bet {
        Bet(event: EventSnapshot(eventID: UUID().uuidString,
                                 name: "Liverpool vs Norwich",
                                 leagueName: "EPL",
                                 sport: "Soccer",
                                 homeTeam: "Liverpool",
                                 awayTeam: "Norwich",
                                 kickoffISO: "2024-08-09T19:00:00"),
            userTip: AnyOutcome(MatchOutcome.homeWin),
            odds: odds,
            status: status)
    }

    func test_totalOdds_isMultiplicative() {
        let slip = BetSlip(
            userID: "u",
            slipNumber: 1,
            bets: [makeBet(odds: 2), makeBet(odds: 1.5), makeBet(odds: 3)],
            stake: Money(10)
        )
        XCTAssertEqual(slip.totalOdds, Decimal(9))
    }

    func test_potentialWin_isStakeTimesOdds() {
        let slip = BetSlip(
            userID: "u",
            slipNumber: 1,
            bets: [makeBet(odds: 2), makeBet(odds: 1.5)],
            stake: Money(10)
        )
        XCTAssertEqual(slip.potentialWin, Money(30))
    }

    func test_recomputedStatus_allPending() {
        let slip = BetSlip(userID: "u", slipNumber: 1,
                           bets: [makeBet(status: .pending), makeBet(status: .pending)],
                           stake: Money(10))
        XCTAssertEqual(slip.recomputedStatus(), .pending)
    }

    func test_recomputedStatus_allWon() {
        let slip = BetSlip(userID: "u", slipNumber: 1,
                           bets: [makeBet(status: .won), makeBet(status: .won)],
                           stake: Money(10))
        XCTAssertEqual(slip.recomputedStatus(), .won)
    }

    func test_recomputedStatus_oneLost_marksLost() {
        let slip = BetSlip(userID: "u", slipNumber: 1,
                           bets: [makeBet(status: .won), makeBet(status: .lost), makeBet(status: .void)],
                           stake: Money(10))
        XCTAssertEqual(slip.recomputedStatus(), .lost)
    }

    func test_recomputedStatus_mixedWonAndVoid_isPartial() {
        let slip = BetSlip(userID: "u", slipNumber: 1,
                           bets: [makeBet(status: .won), makeBet(status: .void)],
                           stake: Money(10))
        XCTAssertEqual(slip.recomputedStatus(), .partiallyWon)
    }
}
