//
//  Money.swift
//  Sports-Almanach
//
//  Precise monetary value built on Decimal to eliminate floating-point drift
//  that plagued the original Double-based balance arithmetic.
//

import Foundation

/// Currency-agnostic monetary amount. All financial state in the app
/// (balance, stake, winnings, odds-multiplied payouts) must use this type.
///
/// Why `Decimal`? `Double` accumulates rounding errors for sums of fractional
/// values (1.10 + 1.10 + 1.10 != 3.30 in IEEE-754). For play money this is
/// merely cosmetic, but it is the wrong default for anything money-shaped.
public struct Money: Hashable, Codable, Sendable, Comparable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {

    public let amount: Decimal
    public let currency: Currency

    public enum Currency: String, Codable, Sendable {
        case eur = "EUR"
    }

    public init(_ amount: Decimal, currency: Currency = .eur) {
        self.amount = amount
        self.currency = currency
    }

    public init(integerLiteral value: Int) {
        self.init(Decimal(value))
    }

    public init(floatLiteral value: Double) {
        self.init(Decimal(value))
    }

    public static let zero: Money = 0

    public var isZero: Bool { amount.isZero }
    public var isPositive: Bool { amount > 0 }
    public var isNegative: Bool { amount < 0 }

    /// Banker's rounding to the smallest currency unit (2 decimal places for EUR).
    public func rounded() -> Money {
        var input = amount
        var output = Decimal()
        NSDecimalRound(&output, &input, 2, .bankers)
        return Money(output, currency: currency)
    }

    // MARK: - Arithmetic
    public static func + (lhs: Money, rhs: Money) -> Money {
        precondition(lhs.currency == rhs.currency, "Cannot add different currencies")
        return Money(lhs.amount + rhs.amount, currency: lhs.currency)
    }

    public static func - (lhs: Money, rhs: Money) -> Money {
        precondition(lhs.currency == rhs.currency, "Cannot subtract different currencies")
        return Money(lhs.amount - rhs.amount, currency: lhs.currency)
    }

    public static func * (lhs: Money, factor: Decimal) -> Money {
        Money(lhs.amount * factor, currency: lhs.currency)
    }

    public static prefix func - (value: Money) -> Money {
        Money(-value.amount, currency: value.currency)
    }

    public static func < (lhs: Money, rhs: Money) -> Bool {
        precondition(lhs.currency == rhs.currency, "Cannot compare different currencies")
        return lhs.amount < rhs.amount
    }

    // MARK: - Formatting
    public func formatted() -> String {
        Money.formatter.string(from: amount as NSDecimalNumber) ?? "\(amount) \(currency.rawValue)"
    }

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = Currency.eur.rawValue
        return f
    }()
}

public extension Decimal {
    /// Convenience for odds math (`stake * odds`) — keeps Money on the lhs.
    static func * (lhs: Decimal, money: Money) -> Money { money * lhs }
}
