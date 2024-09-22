//
//  UserRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class MockUserRepository: UserRepositoryProtocol {
    
    /// Gibt eine Liste von Mock-Benutzern zurück
    func fetchUsers() -> [User] {
        return MockUsers.users
    }
}
