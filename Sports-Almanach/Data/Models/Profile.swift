//
//  User.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID
    let name: String
    let startMoney: Double
    let birthday: Date
}
