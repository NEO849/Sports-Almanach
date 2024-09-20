//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class UserViewModel: ObservableObject {

    private var userRepository = UserRepository()
    @Published var users: [User] = []
    @Published var errorMessage: String?

    init() {
        loadMockUsers()
    }

    func loadMockUsers() {
        self.users = MockUsers.users
    }

    func signIn(email: String, password: String) {
        // Überprüfen, ob der Benutzer existiert 
        if let user = users.first(where: { $0.email == email }) {
            // Erfolgreich angemeldet
            print("Benutzer angemeldet: \(user.name)")
        } else {
            errorMessage = ApiError.requestFailed.errorDescription
        }
    }

    func signUp(username: String, email: String, password: String, passwordRepeat: String, amount: Double, age: Int) {
        // Überprüfen, ob Email und Passwort gültig sind
        guard isValidateEmailAndPassword(email: email, password: password, passwordRepeat: passwordRepeat) else {
            return
        }

        // Berechnet das Geburtsdatum basierend auf dem Alter
        let birthday = Calendar.current.date(byAdding: .year, value: -age, to: Date())!

        // Erstellt den neuen Benutzer
        let newUser = User(id: UUID(), name: username, email: email, startMoney: amount, birthday: birthday)

        // Überprüft, ob der Benutzer gültig ist
        if validateUser(user: newUser) {
            users.append(newUser)
        } else {
            errorMessage = ApiError.decodingFailed.errorDescription
        }
    }

    func validateUser(user: User) -> Bool {
        let age = calculateAge(birthday: user.birthday)
        return age >= 18
    }

    /// Berechnet das Alter basierend auf dem Geburtsdatum
    func calculateAge(birthday: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return ageComponents.year!
    }

    func isValidateEmailAndPassword(email: String, password: String, passwordRepeat: String) -> Bool {
        if !isValidEmail(email) {
            errorMessage = ApiError.invalidURL.errorDescription
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
