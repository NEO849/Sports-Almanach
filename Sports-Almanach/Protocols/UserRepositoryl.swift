//
//  UserRepositoryProtocol.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 22.09.24.
//

import Foundation

/// Leichtere Hanghabung von MockDaten Firebase
protocol UserRepository {
    func fetchUsers() -> [User]
}
