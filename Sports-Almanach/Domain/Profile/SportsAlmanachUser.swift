//
//  SportsAlmanachUser.swift
//  Sports-Almanach
//
//  Authenticated user descriptor — distinct from Profile. AuthService deals
//  with this; Profile is the persisted Firestore document.
//

import Foundation

public struct SportsAlmanachUser: Hashable, Sendable {
    public let id: String      // Firebase UID
    public let email: String

    public init(id: String, email: String) {
        self.id = id
        self.email = email
    }
}
