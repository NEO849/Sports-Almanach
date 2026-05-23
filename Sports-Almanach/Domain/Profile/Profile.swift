//
//  Profile.swift
//  Sports-Almanach
//
//  Domain profile — uses Money for monetary fields. The legacy struct stored
//  `balance: Double` which drifted across additions and was unsafe for any
//  arithmetic we cared about.
//

import Foundation

public struct Profile: Identifiable, Codable, Hashable, Sendable {

    public let id: String                // Firebase Auth UID
    public let username: String
    public let email: String
    public let birthday: Date
    public let startingBalance: Money
    public var balance: Money
    /// Tracked so the birthday bonus is only credited once per calendar year.
    public var lastBirthdayBonusYear: Int?

    public init(id: String,
                username: String,
                email: String,
                birthday: Date,
                startingBalance: Money = AppConstants.Balances.startingBalance,
                balance: Money? = nil,
                lastBirthdayBonusYear: Int? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.birthday = birthday
        self.startingBalance = startingBalance
        self.balance = balance ?? startingBalance
        self.lastBirthdayBonusYear = lastBirthdayBonusYear
    }
}
