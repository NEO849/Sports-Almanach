//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var errorMessages: [UserError] = []
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    @Published var startMoney: Double = 1000.00
    @Published var balance: Double = 0.00 // Dynamisch aktua.
    
    // Validierungslogik für die Anmeldung und Registrierung
    private func validateInputs(username: String, email: String,
                                password: String, passwordRepeat: String, birthday: Date) -> [UserError] {
        var errors: [UserError] = []
        
        if username.isEmpty || username.contains(" ") {
            errors.append(UserError.noSpace)
        }
        
        if !isValidEmail(email) {
            errors.append(UserError.invalidEmail)
        }
        
        if !isPasswordValid(password) {
            errors.append(UserError.invalidPassword)
        }
        
        if password != passwordRepeat {
            errors.append(UserError.passwordMismatch)
        }
        
        if !isOldEnough(birthday: birthday) {
            errors.append(UserError.tooYoung)
        }
        
        return errors // Liste der Fehler zurückgeben
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
    
    func register(username: String, email: String, password: String,
                  passwordRepeat: String, birthday: Date) async {
        
        errorMessages = validateInputs(username: username, email: email,
                                       password: password, passwordRepeat: passwordRepeat, birthday: birthday)
        guard errorMessages.isEmpty else { return }
        
        do {
            try await FirebaseAuthManager.shared.signUp(email: email, password: password)
            
            let db = Firestore.firestore()
            let newProfile = Profile(id: UUID(), name: username, startMoney: 1000, birthday: birthday)
            
            do {
                try db.collection("Profile").document(newProfile.id.uuidString).setData(from: newProfile)
                isRegistered = true
            } catch {
                print("Fehler beim Speichern des Profils: \(error)")
                errorMessage = error.localizedDescription
            }
            
        } catch {
            print("Fehler bei der Registrierung: \(error)")
            errorMessage = error.localizedDescription
        }
    }
    
    func login(email: String, password: String) async {
        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            isLoggedIn = true
        } catch {
            print("Fehler bei der Anmeldung: \(error)")
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        FirebaseAuthManager.shared.signOut()
        isLoggedIn = false
    }
}
