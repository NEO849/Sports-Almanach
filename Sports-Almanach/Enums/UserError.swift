//
//  UserError.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 22.09.24.
//

import Foundation

/// Definiert die möglichen Fehler, die bei der Benutzeranmeldung/-registrierung auftreten können
enum UserError: Error, LocalizedError {
    case emailAlreadyExists
    case emailOrPasswordInvalid
    case userAlreadyExists
    case passwordMismatch
    case invalidPassword
    case invalidExcepted
    case invalidAmount
    case tooYoung
    case noSpace

    // Durch Switch-Case, Fehlermeldung in Deutsch, ohne den rawValue und einfacher Erweiterbarkeit
    var errorDescriptionGerman: String? {
        switch self {
        case .emailAlreadyExists:
            return "E-Mail-Adresse ist ungültig."
        case .emailOrPasswordInvalid:
            return "E-Mail oder Passwort ungültig."
        case .userAlreadyExists:
            return "Benutzer existiert bereits."
        case .passwordMismatch:
            return "Passwörter stimmen nicht überein."
        case .invalidPassword:
            return "Min.8 Zeichen, 1 Zahl, 1 Klein-und Großb. und 1 Sondz."
        case .invalidExcepted:
            return "Min 0Max. Betrag 1000 €."
        case .invalidAmount:
            return "Betrag muss mindestens 1 betragen."
        case .tooYoung:
            return "Mindestalter 18 Jahre!"
        case .noSpace:
            return "Keine Leerzeichen Im Namen"
        }
    }
}
