//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    private var userRepository = UserRepository()
    @Published var errorMessage: String?

    init() {
        loadMockUsers()
    }

    func loadMockUsers() {
        self.users = MockUsers.users
    }

    func signIn(email: String, password: String) {
        // Logik zur Benutzeranmeldung
    }

    func signUp(username: String, email: String, password: String, amount: Double, age: Int) {
        let newUser = User(name: username, email: email, startMoney: amount, age: age)
        
        if userRepository.validateUser(user: newUser) {
            users.append(newUser)
        } else {
            errorMessage = "Benutzer ist nicht gültig!"
        }
    }

    func isValidateEmailAndPassword(email: String, password: String, passwordRepeat: String) -> Bool {
        if !isValidEmail(email) {
            errorMessage = "Ungültige Email Adresse"
            return false
        }

        if !isPasswordValid(password) {
            errorMessage = "Passwort muss min. 8 Zeichen, 1 Zahl, 1 Großbuchstaben und 1 Sonderzeichen enthalten"
            return false
        }

        if password != passwordRepeat {
            errorMessage = "Passwörter müssen identisch sein!"
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
