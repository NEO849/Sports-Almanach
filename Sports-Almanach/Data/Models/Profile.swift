//
//  Profile.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

/// Modell für das Benutzerprofil
struct Profile: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let birthday: Date
    let startMoney: Double
    var balance: Double
    var selectedEventIds: [String] = []
    
    /// Standartwert für ID (UUID als String konventieren), ID von aussen
     init(id: String = UUID().uuidString,
          name: String,
          email: String,
          birthday: Date,
          startMoney: Double,
          balance: Double) {
         self.id = id
         self.name = name
         self.email = email
         self.birthday = birthday
         self.startMoney = startMoney
         self.balance = balance
     }
 }
