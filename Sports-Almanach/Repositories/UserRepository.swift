//
//  UserRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class UserRepository {
    
    func fetchUsers() -> [User] {
        // Hier aus einer Datenbank oder mittelks API
        return MockUsers.users
    }
}
