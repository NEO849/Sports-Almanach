//
//  AppErrors.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 26.02.25.
//

import Foundation

/// Zentrale Fehlerdefinitionen der App
struct AppErrors {
    
    // MARK: - User
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
    
    // MARK: - API Errors
    enum Api: Error, LocalizedError {
        case invalidURL                 // Ungültige URL-Konstruktion
        case requestFailed              // Allgemeiner Netzwerkfehler
        case decodingFailed             // JSON Dekodierungsfehler
        case invalidResponse            // Ungültige HTTP Response
        case httpError(code: Int)       // Spezifischer HTTP Statuscode Fehler
        
        var errorDescriptionGerman: String {
            switch self {
            case .invalidURL:
                return "Die API-URL konnte nicht erstellt werden"
            case .requestFailed:
                return "Die Verbindung zum Server ist fehlgeschlagen"
            case .decodingFailed:
                return "Die Serverdaten konnten nicht verarbeitet werden"
            case .invalidResponse:
                return "Der Server hat eine ungültige Antwort gesendet"
            case .httpError(let code):
                return "Server-Fehler mit Status \(code)"
            }
        }
    }
    
    // MARK: - Authentication
    enum Auth: Error, LocalizedError {
        case noEmail
        case notAuthenticated
        
        var errorDescriptionGerman: String? {
            switch self {
            case .noEmail:
                return "Es wurde keine E-Mail-Adresse für den neu erstellten Benutzer gefunden."
            case .notAuthenticated:
                return "Der Benutzer ist nicht authentifiziert."
            }
        }
    }
}
