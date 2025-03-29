//
//  LoggerService.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 29.03.25.
//

import Foundation
import OSLog

/// Zentrale Logging-Klasse für die gesamte App, Verwendet Apples native OSLog für performantes Logging
class LoggerService {
    
    static let shared = LoggerService()
    
    /// Native Logger-Instanz von Apple
    private let logger: Logger
    private init() {
        self.logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Sports-Almanach", category: "default")
    }
    
    /// Verschiedene Log-Level-Informationen mit zugehörigen Symbolen
    enum LogLevel {
        case debug
        case info
        case warning
        case error
        case success
        
        var symbol: String {
            switch self {
            case .debug: return "🔍"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .success: return "✅"
            }
        }
    }
    
    /// Zentrale Logging-Funktion mit Datei- und Funktionskontext
    /// - Parameters:message,  level: Schweregrad des Logs, file: Automatisch injizierter Dateiname, function: Automatisch injizierter Funktionsname
    func log(
        _ message: String,
        level: LogLevel,
        file: String = #file,
        function: String = #function
    ) {
        // Dateiname aus Pfad extrahieren
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.symbol) [\(fileName)] \(message)"
        
        switch level {
        case .debug:
            logger.debug("\(logMessage)")
        case .info:
            logger.info("\(logMessage)")
        case .warning:
            logger.warning("\(logMessage)")
        case .error:
            logger.error("\(logMessage)")
        case .success:
            logger.notice("\(logMessage)")
        }
        #if DEBUG
        print(logMessage) // Nur im Debug-Modus in Konsole ausgeben
        #endif
    }
}
