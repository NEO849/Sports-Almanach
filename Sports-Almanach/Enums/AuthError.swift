//
//  AuthError.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation

enum AuthError: LocalizedError {
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
