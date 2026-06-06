//
//  AppLogger.swift
//  Sports-Almanach
//
//  Thin wrapper around os.Logger with consistent categories and structured fields.
//  Replaces the scattered `print` calls and emoji-stringified messages
//  that made the legacy code hard to filter in Console.app.
//

import Foundation
import os

/// Categories map to filter-able subsystems in Console / Xcode log filters.
public enum LogCategory: String {
    case auth
    case betting
    case repository
    case ui
    case api
    case lifecycle
}

/// Use through the static methods, e.g. `AppLogger.info("loaded", category: .api)`.
public enum AppLogger {

    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.aidata.Sports-Almanach"

    private static var loggers: [LogCategory: Logger] = [:]
    private static let lock = NSLock()

    private static func logger(for category: LogCategory) -> Logger {
        lock.lock()
        defer { lock.unlock() }
        if let existing = loggers[category] { return existing }
        let new = Logger(subsystem: subsystem, category: category.rawValue)
        loggers[category] = new
        return new
    }

    public static func debug(_ message: @escaping @autoclosure () -> String,
                             category: LogCategory = .lifecycle,
                             file: String = #fileID,
                             line: Int = #line) {
        #if DEBUG
        logger(for: category).debug("\(formatted(message(), file: file, line: line), privacy: .public)")
        #endif
    }

    public static func info(_ message: @escaping @autoclosure () -> String,
                            category: LogCategory = .lifecycle,
                            file: String = #fileID,
                            line: Int = #line) {
        logger(for: category).info("\(formatted(message(), file: file, line: line), privacy: .public)")
    }

    public static func warning(_ message: @escaping @autoclosure () -> String,
                               category: LogCategory = .lifecycle,
                               file: String = #fileID,
                               line: Int = #line) {
        logger(for: category).warning("\(formatted(message(), file: file, line: line), privacy: .public)")
    }

    public static func error(_ message: @escaping @autoclosure () -> String,
                             category: LogCategory = .lifecycle,
                             file: String = #fileID,
                             line: Int = #line) {
        logger(for: category).error("\(formatted(message(), file: file, line: line), privacy: .public)")
    }

    /// Use for failures we expect to investigate post-mortem (e.g. balance drift,
    /// repository corruption). Mark with `.fault` so it surfaces in Crashlytics.
    public static func fault(_ message: @escaping @autoclosure () -> String,
                             category: LogCategory = .lifecycle,
                             file: String = #fileID,
                             line: Int = #line) {
        logger(for: category).fault("\(formatted(message(), file: file, line: line), privacy: .public)")
    }

    private static func formatted(_ message: String, file: String, line: Int) -> String {
        "[\(file):\(line)] \(message)"
    }
}
