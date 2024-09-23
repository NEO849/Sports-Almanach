//
//  UserError.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 22.09.24.
//

import Foundation

/// Definiert die möglichen Fehler, die bei der Benutzeranmeldung/-registrierung auftreten können
enum UserError: Error, LocalizedError {
    case emailInvalid
    case emailAlreadyExists
    case userAlreadyExists
    case tooYoung
    case passwordMismatch
    case invalidPassword
    case maxAmountExceeded
    case emailOrPasswordInvalid

    // Durch Switch-Case, Fehlermeldung in Deutsch, ohne den rawValue und einfacher Erweiterbarkeit
    var errorDescriptionGerman: String? {
        switch self {
        case .emailInvalid:
            return "E-Mail-Adresse ist ungültig."
        case .emailAlreadyExists:
            return "E-Mail-Adresse ist bereits registriert."
        case .userAlreadyExists:
            return "Benutzer existiert bereits."
        case .tooYoung:
            return "Benutzer muss mindestens 18 Jahre alt sein."
        case .passwordMismatch:
            return "Passwörter stimmen nicht überein."
        case .invalidPassword:
            return "Passwort muss mindestens 8 Zeichen, 1 Zahl, 1 Großbuchstaben und 1 Sonderzeichen enthalten."
        case .maxAmountExceeded:
            return "Maximaler Startbetrag beträgt 1000 €."
        case .emailOrPasswordInvalid:
            return "E-Mail oder Passwort ungültig."
        }
    }
}
