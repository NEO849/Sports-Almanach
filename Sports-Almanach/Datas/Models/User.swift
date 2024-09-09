//
//  User.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

struct User {
    let name: String
    let email: String
    let startMoney: Double
    let age: Int               // Muss mindestens 18 Jahre alt sein, um sich zu registrieren

    // Benutzer gelten als gleich, wenn ihre E-Mail-Adressen übereinstimmen
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
}
