//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    
    // Stellt die Benutzerdaten bereit (wird über Dependency Injection gesetzt)
    private var userRepository: UserRepository
    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var errorMessages: [UserError] = []
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    
    /// Initialisierung mit Dependency Injection
    init(repository: UserRepository = MockUserRepository()) {
        self.userRepository = repository
        loadUsers()
    }
    
    /// Lädt die Benutzer aus dem Repo, weis nicht woher die Daten stammen
    func loadUsers() {
        self.users = userRepository.fetchUsers()
    }
    
    /// Anmeldung anhand von E-Mail und Passwort
    func logIn(email: String, password: String) {
        
        /// Platzhalter für Firebase-Login
        
        // Lokale Validierung für Testzwecke
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            print("Benutzer angemeldet: \(user.name)")
            isLoggedIn = true  // Wegen Navi zur ContentView
            errorMessage = nil // Zurücksetzen
        } else {
            errorMessage = UserError.emailOrPasswordInvalid.errorDescriptionGerman
        }
    }
    
    /// Registrierung
    func signUp(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) {
        print("Starten vom SignUp Prozess...")
        
        // Validierung der Eingaben
        if let error = validateInputs(username: username, email: email, password: password, passwordRepeat: passwordRepeat, birthday: birthday) {
            errorMessage = error.errorDescriptionGerman
            return
        }
        
        /// Platzhalter für Firebase-Registrierung
        
        // Fehlerfrei -> Zur ContentView navi.
        isRegistered = true
    }
    
}

// Validierungslogik für die Anmeldung und Registrierung
private func validateInputs(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) -> UserError? {
    
    if username.isEmpty || username.contains(" ") {
        return UserError.noSpace
    }
    
   
    if !isValidEmail(email) {
        return UserError.emailAlreadyExists
    }
    
    if !isPasswordValid(password) {
        return UserError.invalidPassword
    }
    
    if password != passwordRepeat {
        return UserError.passwordMismatch
    }
    
    if !isOldEnough(birthday: birthday) {
        return UserError.tooYoung
    }
    
    return nil // Keine Fehler
}

///Abmelden
func signOut() {
    // TO DO
}

// Überprüft Mindestalter
private func isOldEnough(birthday: Date) -> Bool {
    let age = calculateAge(birthday: birthday)
    return age >= 18
}

// Berechnet das Alter basierend auf dem Geburtsdatum
private func calculateAge(birthday: Date) -> Int {
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
    return ageComponents.year!
}


// Ob E-Mail gültig ist
private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

// Ob Passwort den Anforderungen entspricht
private func isPasswordValid(_ password: String) -> Bool {
    let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
    let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    return passwordPred.evaluate(with: password)
}

