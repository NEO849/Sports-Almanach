//
//  AppErrors.swift
//  Sports-Almanach
//
//  Centralised error catalogue. Each domain area gets its own enum so call
//  sites can pattern-match on a finite surface.
//

import Foundation

public enum AppErrors {

    // MARK: - User input / registration
    public enum User: Error, LocalizedError, Hashable {
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

        public var errorDescriptionGerman: String? {
            switch self {
            case .userInputIsEmpty:        return "Bitte Benutzerdaten eingeben."
            case .emailOrPasswordInvalid:  return "E-Mail oder Passwort ungültig."
            case .noSpace:                 return "Leerzeichen sind nicht erlaubt."
            case .emailAlreadyExists:      return "Diese E-Mail-Adresse ist bereits registriert."
            case .invalidEmail:            return "E-Mail-Adresse ist ungültig."
            case .invalidPassword:         return "Min. 8 Zeichen, je 1 Zahl, Klein-/Großbuchstabe und Sonderzeichen."
            case .passwordMismatch:        return "Passwörter stimmen nicht überein."
            case .tooYoung:                return "Mindestalter \(AppConstants.Validation.minimumAgeYears) Jahre."
            case .unknownError:            return "Unbekannter Fehler."
            case .userNotFound:            return "Benutzer wurde nicht gefunden."
            }
        }

        public var errorDescription: String? { errorDescriptionGerman }
    }

    // MARK: - HTTP / API
    public enum Api: Error, LocalizedError {
        case invalidURL
        case requestFailed
        case decodingFailed
        case invalidResponse
        case httpError(code: Int)

        public var errorDescription: String? {
            switch self {
            case .invalidURL:          return "Ungültige API-URL."
            case .requestFailed:       return "Verbindung zum Server fehlgeschlagen."
            case .decodingFailed:      return "Antwort konnte nicht verarbeitet werden."
            case .invalidResponse:     return "Ungültige Server-Antwort."
            case .httpError(let code): return "Server-Fehler (\(code))."
            }
        }
    }

    // MARK: - Auth
    public enum Auth: Error, LocalizedError {
        case noEmail
        case notAuthenticated
        case signOutFailed

        public var errorDescription: String? {
            switch self {
            case .noEmail:          return "Keine E-Mail-Adresse vorhanden."
            case .notAuthenticated: return "Bitte erneut anmelden."
            case .signOutFailed:    return "Abmelden fehlgeschlagen."
            }
        }
    }

    // MARK: - Betting domain
    public enum Bet: Error, LocalizedError {
        case insufficientFunds
        case noBetsOnSlip
        case stakeBelowMinimum
        case balanceUnreadable
        case slipNotFound
        case eventNotFinished
        case permissionDenied

        public var errorDescription: String? {
            switch self {
            case .insufficientFunds:  return "Nicht genügend Guthaben."
            case .noBetsOnSlip:       return "Wettschein enthält keine Wetten."
            case .stakeBelowMinimum:  return "Wetteinsatz zu niedrig."
            case .balanceUnreadable:  return "Kontostand konnte nicht gelesen werden."
            case .slipNotFound:       return "Wettschein nicht gefunden."
            case .eventNotFinished:   return "Event hat noch kein Ergebnis."
            case .permissionDenied:   return "Keine Berechtigung für diese Aktion. Bitte Firestore Security Rules überprüfen."
            }
        }
    }
}
