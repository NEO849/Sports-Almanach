//
//  AppConstants.swift
//  Sports-Almanach
//
//  Central place for cross-cutting constants. Anything that previously lived
//  as a private static let in some random Utils file belongs here, behind a
//  domain-scoped enum so call sites stay readable.
//

import Foundation

public enum AppConstants {

    public enum Balances {
        public static let startingBalance: Money = 1000
        public static let birthdayBonus: Money = 2500
        public static let minimumStake: Money = 1
    }

    public enum Validation {
        public static let minimumAgeYears: Int = 18
    }

    public enum API {
        public static let sportsDBBase = "https://www.thesportsdb.com/api/v1/json/3"
        public static let maxRetries = 3
        public static let baseBackoffSeconds: TimeInterval = 2.0
        public static let requestTimeoutSeconds: TimeInterval = 20.0
    }

    public enum FirestoreCollections {
        public static let profiles = "Profile"
        public static let betSlips = "BetSlips"
        public static let userEventsSubcollection = "events"
        public static let betSlipBetsSubcollection = "bets"
    }

    public enum Splash {
        public static let videoFileName = "splashintro"
        public static let totalSeconds: Double = 3.3
    }
}
