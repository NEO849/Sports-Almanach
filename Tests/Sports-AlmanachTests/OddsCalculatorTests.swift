//
//  OddsCalculatorTests.swift
//  Sports-AlmanachTests
//

import XCTest
@testable import Sports_Almanach

final class OddsCalculatorTests: XCTestCase {

    func test_unknownScores_returnsBaseOdds() {
        let bundle = OddsCalculator.odds(homeScore: nil, awayScore: nil)
        XCTAssertEqual(bundle.homeWin, Decimal(2.0))
        XCTAssertEqual(bundle.draw,    Decimal(3.0))
        XCTAssertEqual(bundle.awayWin, Decimal(2.5))
    }

    func test_zeroScores_returnsBaseOdds() {
        let bundle = OddsCalculator.odds(homeScore: 0, awayScore: 0)
        XCTAssertEqual(bundle.homeWin, Decimal(2.0))
        XCTAssertEqual(bundle.draw,    Decimal(3.0))
        XCTAssertEqual(bundle.awayWin, Decimal(2.5))
    }

    func test_homeBlowout_favourisesHome() {
        let bundle = OddsCalculator.odds(homeScore: 4, awayScore: 0)
        // home odds: (away+1)/(home+1) = 1/5 = 0.2 -> clamped to 1.2 minimum
        XCTAssertEqual(bundle.homeWin, Decimal(1.2))
        // away odds: (home+1)/(away+1) = 5/1 = 5.0
        XCTAssertEqual(bundle.awayWin, Decimal(5))
        // diff > 1 -> blowout draw odds
        XCTAssertEqual(bundle.draw, Decimal(5))
    }

    func test_tightMatch_useTightDrawOdds() {
        let bundle = OddsCalculator.odds(homeScore: 1, awayScore: 1)
        XCTAssertEqual(bundle.draw, Decimal(3))
    }
}
