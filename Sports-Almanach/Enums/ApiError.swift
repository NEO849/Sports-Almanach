//
//  ApiError.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import Foundation

/// Definiert die möglichen Fehler, die bei der API-Anfrage auftreten können
enum ApiError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed

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
