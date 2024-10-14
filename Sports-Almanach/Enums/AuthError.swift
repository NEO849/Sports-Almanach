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
    
    var errorDescription: String { "Auth Error" }
    
    var localizedDescription: String {
        switch self {
        case .noEmail:
            "No email was found on newly created user."
        case .notAuthenticated:
            "The user is not authenticated."
        }
    }
}
