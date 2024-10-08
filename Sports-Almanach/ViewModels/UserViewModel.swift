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
    @Published var users: [User] = [] // Zum Testen
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var errorMessages: [UserError] = []
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    @Published var startMoney: Double = 1000.00
    @Published var balance: Double = 0.00 // Dynamisch aktua.
    
    /// Initialisierung mit Dependency Injection (Testweise MockUserRepository)
    init(repository: UserRepository = MockUserRepository()) {
        self.userRepository = repository
        loadUsers()
    }
    
    /// Lädt die Benutzer aus dem Repo, weis nicht woher die Daten stammen
    func loadUsers() {
        /// Platzhalter Firebase: Hier werden später die Benutzerdaten aus Firebase geladen
        self.users = userRepository.fetchUsers()
    }
    
    /// Anmeldung anhand von E-Mail und Passwort
    func logIn(email: String, password: String) {
        
        /// Platzhalter Firebase: Hier wird Firebase Login-Logik eingefügt
        
        // Lokale Validierung für Testzwecke
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            print("Benutzer angemeldet: \(user.name)")
            currentUser = user
            balance = user.startMoney  // Setzt aktuellen Kontostand
            isLoggedIn = true          // Zur ContentView
            errorMessage = nil         // Zurücksetzen
        } else {
            errorMessage = UserError.emailOrPasswordInvalid.errorDescriptionGerman
        }
    }
    
    /// Registrierung eines neuen Benutzers
    func signUp(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) {
        print("Starten vom SignUp Prozess...")
        
        // Validierung der Eingaben zum Testen
        if let error = validateInputs(username: username, email: email, password: password, passwordRepeat: passwordRepeat, birthday: birthday) {
            errorMessage = error.errorDescriptionGerman
            return
        }
        
        /// Platzhalter Firebase: Registrierungslogik einfügen
        
        // Fehlerfrei -> Zur ContentView navi.
        isRegistered = true
    }
    
    ///Abmelden
    func signOut() {
        /// Platzhalter Firebase: Hier wird Firebase-Abmeldung eingefügt
    }
    
    // Validierungslogik für die Anmeldung und Registrierung
    private func validateInputs(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) -> UserError? {
        
        if username.isEmpty || username.contains(" ") {
            return UserError.noSpace
        }
        
        if !emailAlreadyExists(email) {
            return UserError.emailAlreadyExists
        }
        
        if !isValidEmail(email) {
            return UserError.invalidEmail
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
    
    // Überprüft Mindestalter
    private func isOldEnough(birthday: Date) -> Bool {
        let age = calculateAge(birthday: birthday)
        return age >= 18
    }
    
    // Berechnet das Alter basierend auf dem Geburtsdatum
    private func calculateAge(birthday: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return ageComponents.year ?? 0 // Option, zwecks abstürzen
    }
    
    // Ob die E-Mail bereits existiert
    private func emailAlreadyExists(_ email: String) -> Bool {
        return users.contains { $0.email == email }
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
}
