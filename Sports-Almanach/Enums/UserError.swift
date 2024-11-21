//
//  UserError.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 22.09.24.
//

import Foundation

/// Definiert die möglichen Fehler, die bei der Benutzeranmeldung/-registrierung auftreten können
enum UserError: Error, LocalizedError {
    case userInputIsEmpty
    case emailOrPasswordInvalid
    case noSpace
    case emailAlreadyExists
    case invalidEmail
    case invalidPassword
    case passwordMismatch
    case tooYoung
    case unknownError

    /// Durch Switch-Case, Fehlermeldung in Deutsch, ohne den rawValue und einfacher Erweiterbarkeit
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
        }
    }
}
