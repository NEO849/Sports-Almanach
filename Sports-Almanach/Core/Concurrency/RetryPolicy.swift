//
//  RetryPolicy.swift
//  Sports-Almanach
//
//  Bounded exponential retry helper for transient network failures.
//  Replaces the hand-rolled retry loop in the legacy EventRepository.
//

import Foundation

public struct RetryPolicy: Sendable {
    public let maxAttempts: Int
    public let baseDelay: TimeInterval
    /// Multiplier for the next attempt's delay. Caps growth to avoid pathological waits.
    public let backoffMultiplier: Double
    /// Maximum delay between attempts.
    public let maxDelay: TimeInterval

    public init(maxAttempts: Int = AppConstants.API.maxRetries,
                baseDelay: TimeInterval = AppConstants.API.baseBackoffSeconds,
                backoffMultiplier: Double = 1.6,
                maxDelay: TimeInterval = 8.0) {
        self.maxAttempts = maxAttempts
        self.baseDelay = baseDelay
        self.backoffMultiplier = backoffMultiplier
        self.maxDelay = maxDelay
    }

    public static let `default` = RetryPolicy()

    public func delay(forAttempt attempt: Int) -> TimeInterval {
        // attempt is 1-indexed; first retry waits baseDelay, then grows.
        let raw = baseDelay * pow(backoffMultiplier, Double(max(0, attempt - 1)))
        return min(raw, maxDelay)
    }
}

public enum Retry {
    /// Executes `work` up to `policy.maxAttempts` times, sleeping between attempts.
    /// Throws the last error if all attempts fail. Honors task cancellation.
    public static func run<T>(_ policy: RetryPolicy = .default,
                              operation: @Sendable () async throws -> T) async throws -> T {
        var lastError: Error?
        for attempt in 1...policy.maxAttempts {
            try Task.checkCancellation()
            do {
                return try await operation()
            } catch {
                lastError = error
                if attempt == policy.maxAttempts { break }
                let delay = policy.delay(forAttempt: attempt)
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        throw lastError ?? AppErrors.Api.requestFailed
    }
}
