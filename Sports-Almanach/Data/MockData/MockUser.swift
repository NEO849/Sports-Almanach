//
//  MockUser.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

/// Mockdaten für Benutzerr
struct MockUsers {
    
    static let users: [User] = [
        User(id: UUID(),
             name: "Lui Cypher",
             email: "luicypher@example.com",
             password: "As123456!",
             startMoney: 10000,
             birthday: Calendar.current.date(byAdding: .year, value: -30, to: Date())! // Berechnet das Datum um 30 Jahre zurück. Ducrch ! gewährleistet das der wert da ist
             
            )
    ]
}
