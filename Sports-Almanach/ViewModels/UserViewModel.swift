//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

class UserViewModel: ObservableObject {
    
    // Stellt die Benutzerdaten bereit (wird über Dependency Injection gesetzt)
    private var userRepository: UserRepositoryProtocol
    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    
    /// Initialisierung mit Dependency Injection
    init(repository: UserRepositoryProtocol = MockUserRepository()) {
        self.userRepository = repository
        loadUsers()
    }
    
    /// Lädt die Benutzer aus dem Repo, weis nicht woher die Daten stammen
    func loadUsers() {
        self.users = userRepository.fetchUsers()
    }
    
    /// Anmeldung anhand von E-Mail und Passwort
    func signIn(email: String, password: String) {
        // Ob der Benutzer mit der E-Mail existiert
        if let user = users.first(where: { $0.email == email }) {
            print("Benutzer angemeldet: \(user.name)")
            isLoggedIn = true // Status auf true, wegen Navigation in der RegisterView
        } else {
            errorMessage = UserError.emailAlreadyExists.errorDescription
        }
    }
    
    /// Rregistrierung
    func signUp(username: String, email: String, password: String, passwordRepeat: String, amount: Double, birthdate: Date) {
        // Überprüft Eingaben (E-Mail und Passwort)
        guard isValidateEmailAndPassword(email: email, password: password, passwordRepeat: passwordRepeat) else {
            return
        }
        
        // Erstellt einen neuen Benutzer
        let newUser = User(id: UUID(), name: username, email: email, password: password, startMoney: amount, birthday: birthdate)

        // Ob der Benutzer gültig ist
        if validateUser(user: newUser) {
            users.append(newUser)  // Fügt den Benutzer der Liste hinzu
            isRegistered = true    // Status auf true, wegen Navigation in der RegisterView
        } else {
            errorMessage = UserError.tooYoung.errorDescription
        }
    }
    
    /// Überprüft Mindestalter
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
    
    /// Ob die E-Mail und das Passwort den Anforderungen entsprechen
    func isValidateEmailAndPassword(email: String, password: String, passwordRepeat: String) -> Bool {
        if !isValidEmail(email) {
            errorMessage = UserError.emailInvalid.errorDescription
            return false
        }
        
        if !isPasswordValid(password) {
            errorMessage = UserError.invalidPassword.errorDescription
            return false
        }
        
        if password != passwordRepeat {
            errorMessage = UserError.passwordMismatch.errorDescription
            return false
        }
        
        return true
    }
    
    /// Ob die E-Mail gültig ist
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /// Ob das Passwort den Anforderungen entspricht
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
