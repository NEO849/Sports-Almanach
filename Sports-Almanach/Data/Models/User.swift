//
//  User.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let startMoney: Double
    let birthday: Date // Muss mindestens 18 Jahre alt sein, um sich zu registrieren

    // Benutzer gelten als gleich, wenn ihre ID übereinstimmen
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
