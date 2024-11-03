//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    
    @Published var showError: Bool = false
    @Published var errorMessage: String?  // Login-Fehler
    @Published var errorMessages: [UserError] = []  // Registrierungs-Fehler
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    @Published var startMoney: Double = 1000.00
    @Published var balance: Double = 1000.00
    @Published var userBirthday: Timestamp?
    @Published var userProfile: Profile?
    
    init() {
        BirthdayChecker.scheduleBirthdayCheck(for: self)
    }
    
    /// --------------  Authentifizierung  --------------
    
    func register(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) async {
        
        // Eingaben validieren und Fehler speichern
        errorMessages = validateInputs(username: username, email: email, password: password, passwordRepeat: passwordRepeat, birthday: birthday)
        
        guard errorMessages.isEmpty else {
            return
        }
        
        // Firebase registrieren
        do {
            try await FirebaseAuthManager.shared.signUp(email: email, password: password)
            // Neues Profil erstellen
            let datab = Firestore.firestore()
            let newProfile = Profile(id: UUID(), name: username, startMoney: startMoney, birthday: birthday, balance: startMoney)
            
            // Profil in Firestore speichern
            do {
                try datab.collection("Profile").document(newProfile.id.uuidString).setData(from: newProfile)
                print("Profil erstellt mit ID: \(newProfile.id.uuidString)")
                isRegistered = true
            } catch {
                print("Fehler beim Speichern des Profils: \(error)")
                errorMessage = error.localizedDescription
            }
            
        } catch {
            print("Fehler bei der Registrierung: \(error)")
            errorMessages.append(.emailOrPasswordInvalid)  // Fehler zur Liste hinzufügen
        }
    }
    
    // Anmeldung
    func login(email: String, password: String) async {
        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            isLoggedIn = true
            await loadUserProfile()
        } catch {
            print("Fehler bei der Anmeldung: \(error)")
            errorMessage = UserError.emailOrPasswordInvalid.errorDescription
        }
    }
    
    func logout() {
        FirebaseAuthManager.shared.signOut()
        isLoggedIn = false
    }
    
    
    /// --------------  Firestore, Profile Laden, Updaten  --------------
    
    func loadUserProfile() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return } // Ob der Benutzer eingeloggt ist
        let datab = Firestore.firestore()
        
        // Profil laden
        do {
            let document = try await datab.collection("Profile").document(userId).getDocument()
            
            // ... Dokument existiert, Profil und balance setzen
            if document.exists {
                self.userProfile = try document.data(as: Profile.self)
                self.balance = self.userProfile?.balance ?? 0.0
            } else {
                print("Profil nicht gefunden")
            }
        } catch {
            print("Fehler beim Laden des Profils: \(error)")
            errorMessage = error.localizedDescription
        }
    }
    
    func updateProfile(newBalance: Double) {
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        let dataB = Firestore.firestore()
        let profileData: [String: Any] = ["balance": newBalance]  // Balance
        dataB.collection("Profile").document(userId).updateData(profileData) { error in
            if let error = error {
                print("Fehler beim Aktualisieren des Kontostands: \(error)")
            } else {
                print("Kontostand erfolgreich aktualisiert.")
                self.balance = newBalance // UI aktualisieren
                
            }
        }
    }
    
    func resetBalance() {
        if balance <= 0 {
            self.balance = startMoney
            self.balance += startMoney
            updateProfile(newBalance: self.balance)
        }
    }
    
    func updateBalance(newBalanceAfterBet: Double) {
        self.balance = newBalanceAfterBet
        resetBalance()
        updateProfile(newBalance: newBalanceAfterBet)
    }
    
    
    /// --------------  Validierung  --------------
    
    private func validateInputs(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) -> [UserError] {
        var errors: [UserError] = []
        
        if username.isEmpty {
            errors.append(UserError.usernameEmpty)
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
        
        return errors
    }
    
    
    /// --------------  Utils  --------------
    
    private func isOldEnough(birthday: Date) -> Bool {
        let age = calculateAge(birthday: birthday)
        return age >= 18
    }
    
    private func calculateAge(birthday: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return ageComponents.year ?? 0
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
    
    func checkUserBirthday() {
        guard let userId = FirebaseAuthManager.shared.userID, let userBirthday = userBirthday else { return }
        BirthdayChecker.checkBirthday(userId: userId, birthday: userBirthday)
    }
}
