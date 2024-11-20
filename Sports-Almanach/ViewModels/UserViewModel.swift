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
        // Tägliche Überprüfung des Geburtstags planen
        BirthdayUtils.dailyBirthdayCheck(for: self)
    }
    
    // Authentifizierung - Registrierung
    func register(username: String, email: String, password: String, passwordRepeat: String, birthday: Date) async {
        errorMessages = ValidationUtils.validateRegistrationInputs(username: username, email: email, password: password, passwordRepeat: passwordRepeat, birthday: birthday)
        
        guard errorMessages.isEmpty else {
            return
        }
        
        // Registrierung versuchen
        do {
            try await FirebaseAuthManager.shared.signUp(email: email, password: password)
            let datab = Firestore.firestore()
            let newProfile = Profile(id: UUID(), name: username, startMoney: startMoney, birthday: birthday, balance: startMoney)
            
            // Benutzer-ID holen
            guard let userId = FirebaseAuthManager.shared.userID else {
                print("Auth-Fehler: Keine gültige userId")
                return
            }
            
            // Profil in Firestore speichern
            try datab.collection("Profile").document(userId).setData(from: newProfile)
            isRegistered = true
        } catch {
            errorMessage = error.localizedDescription
            errorMessages.append(.emailOrPasswordInvalid)
        }
    }
    
    // Anmeldung
    func login(email: String, password: String) async {
        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            isLoggedIn = true
            await loadUserProfile()
        } catch {
            errorMessage = UserError.emailOrPasswordInvalid.errorDescription
        }
    }
    
    // Logout
    func logout() {
        FirebaseAuthManager.shared.signOut()
        isLoggedIn = false
    }
    
    // Profil laden
    func loadUserProfile() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        let datab = Firestore.firestore()
        
        do {
            let document = try await datab.collection("Profile").document(userId).getDocument()
            if document.exists {
                self.userProfile = try document.data(as: Profile.self)
                self.balance = self.userProfile?.balance ?? 0.0
            } else {
                print("Fehler beim Laden des Profils")
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Profil aktualisieren
    func updateProfile(newBalance: Double) {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        let dataB = Firestore.firestore()
        let profileData: [String: Any] = ["balance": newBalance]
        dataB.collection("Profile").document(userId).updateData(profileData) { error in
            if let error = error {
                print("Fehler beim Aktualisieren des Kontostands: \(error)")
            } else {
                self.balance = newBalance
            }
        }
    }
    
    func checkUserBirthday() {
        guard let userId = FirebaseAuthManager.shared.userID, let birthday = userBirthday else {
            print("Fehler: Benutzer-ID oder Geburtstag fehlt.")
            return
        }
        BirthdayUtils.checkBirthday(userId: userId, birthday: birthday)
    }
    
    // Kontostand zurücksetzen, wenn er negativ ist
    func resetBalance() {
        if balance == 0 {
            self.balance = startMoney
            updateProfile(newBalance: self.balance)
        }
    }
    
    // Kontostand aktualisieren
    func updateBalance(newBalanceAfterBet: Double) {
        self.balance = newBalanceAfterBet
        resetBalance()
        updateProfile(newBalance: newBalanceAfterBet)
    }
}
