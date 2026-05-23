//
//  MoneyTests.swift
//  Sports-AlmanachTests
//

import XCTest
@testable import Sports_Almanach

final class MoneyTests: XCTestCase {

    func test_zero_isZero() {
        XCTAssertTrue(Money.zero.isZero)
        XCTAssertFalse(Money.zero.isPositive)
        XCTAssertFalse(Money.zero.isNegative)
    }

    func test_addition_isCommutative() {
        let a: Money = 10
        let b: Money = 5
        XCTAssertEqual(a + b, b + a)
    }

    func test_subtraction_doesNotDriftOnRepeatedSmallValues() {
        // The exact bug Decimal fixes: 1.10 added 10× must equal 11.00.
        var sum = Money.zero
        for _ in 0..<10 {
            sum = sum + Money(Decimal(string: "1.10")!)
        }
        XCTAssertEqual(sum, Money(11))
    }

    func test_multiplication_byDecimal() {
        let m = Money(10) * Decimal(2.5)
        XCTAssertEqual(m, Money(25))
    }

    func test_rounding_appliesBankersRoundingToTwoPlaces() {
        let m = Money(Decimal(string: "1.235")!).rounded()
        // Banker's rounding: .5 -> nearest even -> 1.24
        XCTAssertEqual(m, Money(Decimal(string: "1.24")!))
    }

    func test_comparison() {
        XCTAssertLessThan(Money(1), Money(2))
        XCTAssertEqual(Money(5), Money(5))
    }

    func test_negation() {
        let m = Money(10)
        XCTAssertEqual(-m, Money(-10))
    }
}
