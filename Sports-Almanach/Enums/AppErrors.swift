//
//  AppErrors.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 26.02.25.
//

import Foundation

/// Namespace to group all application errors
/// - Provides a structured way to organize different error types
/// - Improves code organization by keeping related error definitions together
struct AppErrors {
    
    // MARK: - User Authentication Errors
    /// Defines possible errors that can occur during user registration/login
    /// - Implements LocalizedError for better error handling in UI
    /// - Provides German error descriptions for user-facing messages
    enum User: Error, LocalizedError {
        case userInputIsEmpty
        case emailOrPasswordInvalid
        case noSpace
        case emailAlreadyExists
        case invalidEmail
        case invalidPassword
        case passwordMismatch
        case tooYoung
        case unknownError
        case userNotFound

        /// Returns localized German error description
        /// - Provides user-friendly error messages
        /// - Can be extended to support multiple languages
        var errorDescriptionGerman: String? {
            switch self {
            case .userInputIsEmpty:
                return "Bitte Benutzerdaten eingeben!"
            case .emailOrPasswordInvalid:
                return "E-Mail oder Passwort ungültig."
            case .noSpace:
                return "Am Anfang oder im Passwort sind keine Leerzeichen erlaubt"
            case .emailAlreadyExists:
                return "E-Mail-Adresse Existiert bereits."
            case .invalidEmail:
                return "E-Mail-Adresse ist ungültig."
            case .invalidPassword:
                return "Min.8 Zeichen, 1 Zahl, 1 Klein-und Großb. und 1 Sondz."
            case .passwordMismatch:
                return "Passwörter stimmen nicht überein."
            case .tooYoung:
                return "Mindestalter 18 Jahre!"
            case .unknownError:
                return "Unbekannter Fehler."
            case .userNotFound:
                return "Benutzer wurde nicht gefunden."
            }
        }
    }
    
    // MARK: - Authentication Session Errors
    /// Defines authentication state errors
    /// - Used for tracking the user's authentication session
    enum Auth: Error, LocalizedError {
        case noEmail
        case notAuthenticated
        
        /// Returns localized German error description
        var errorDescriptionGerman: String? {
            switch self {
            case .noEmail:
                return "Es wurde keine E-Mail-Adresse für den neu erstellten Benutzer gefunden."
            case .notAuthenticated:
                return "Der Benutzer ist nicht authentifiziert."
            }
        }
    }
    
    // MARK: - API Communication Errors
    /// Defines possible errors that can occur during API requests
    /// - Covers network, data parsing, and URL formation errors
    enum Api: Error, LocalizedError {
        case invalidURL
        case requestFailed
        case decodingFailed

        /// Returns localized German error description
        var errorDescriptionGerman: String? {
            switch self {
            case .invalidURL:
                return "Die URL war ungültig"
            case .requestFailed:
                return "Die Anfrage an den Server ist fehlgeschlagen."
            case .decodingFailed:
                return "Die Daten konnten nicht verarbeitet werden."
            }
        }
    }
}
