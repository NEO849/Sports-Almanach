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
    @Published var errorMessages: [UserError] = [] // Register-Fehler
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    @Published var startMoney: Double = 1000.00
    @Published var balance: Double = 1000.00
    @Published var userBirthday: Timestamp?
    @Published var userProfile: Profile?
    
    // FirestoreRepository
    private let fsRepository = FirestoreRepository()
    
    init() {
        /// Tägliche Überprüfung des Geburtstags planen
        BirthdayUtils.dailyBirthdayCheck(for: self)
    }
    
    // MARK: - Login Function
    func login(email: String, password: String) async {
        guard !email.isEmpty || !password.isEmpty else {
            self.errorMessage = UserError.userInputIsEmpty.errorDescriptionGerman
            self.showError = true
            return
        }
        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            isLoggedIn = true
            await loadUserProfile()
        } catch {
            self.errorMessage = UserError.emailOrPasswordInvalid.errorDescriptionGerman
            self.showError = true
        }
    }
    
    // MARK: - Registration
    func register(
        username: String,
        email: String, password: String,
        passwordRepeat: String,
        birthday: Date) async {
        errorMessages = ValidationUtils.validateRegistrationInputs(username: username, email: email, password: password, passwordRepeat: passwordRepeat, birthday: birthday)
        
        guard errorMessages.isEmpty else { return }
        
        // Überprüfen, ob die E-Mail bereits existiert
        let emailExists = await emailAlreadyExists(email: email)
        if emailExists {
            errorMessages.append(.emailAlreadyExists)
            return
        }
        do {
            // Firebase Anmeldung
            try await FirebaseAuthManager.shared.signUp(email: email, password: password)
            
            guard let userId = FirebaseAuthManager.shared.userID else {
                print("Auth-Fehler: Keine gültige userId")
                return
            }
            
            let newProfile = Profile(
                id: UUID().uuidString,
                name: username,
                email: email,
                birthday: birthday,
                startMoney: startMoney,
                balance: startMoney
            )
            
            try await fsRepository.saveProfile(newProfile, userId: userId)
            isRegistered = true
        } catch {
            print("Auth-Fehler: Beim Registrieren ist ein Fehler aufgetreten")
        }
    }
    
    // MARK: - Logout Function
    func logout() {
        FirebaseAuthManager.shared.signOut()
        isLoggedIn = false
    }
    
    // MARK: - Load Profile
    func loadUserProfile() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            if let profile = try await fsRepository.loadProfile(userId: userId) {
                self.userProfile = profile
                self.balance = profile.balance
            } else {
                print("Fehler beim Laden des Profils")
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Email Check
    func emailAlreadyExists(email: String) async -> Bool {
        do {
            return try await fsRepository.emailExists(email)
        } catch {
            print("Fehler beim Überprüfen der Email: \(error)")
            return false
        }
    }
    
    // MARK: - Update Profile
    func updateProfile(newBalance: Double) {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        Task {
            do {
                try await fsRepository.updateBalance(userId: userId, newBalance: newBalance)
                await MainActor.run {
                    self.balance = newBalance
                }
            } catch {
                print("Fehler beim Aktualisieren des Kontostands: \(error)")
            }
        }
    }
    
    // Birthday related functions remain the same
    func updateMoneyUserBirthday() {
        guard let userId = FirebaseAuthManager.shared.userID, let birthday = userBirthday else {
            print("Fehler: Benutzer-ID oder Geburtstag fehlt.")
            return
        }
        BirthdayUtils.checkBirthday(userId: userId, birthday: birthday)
    }
    
    // Balance related functions remain the same
    func resetBalance() {
        if balance == 0 {
            self.balance = startMoney
            updateProfile(newBalance: self.balance)
        }
    }
    
    func updateBalance(newBalanceAfterBet: Double) {
        self.balance = newBalanceAfterBet
        resetBalance()
        updateProfile(newBalance: newBalanceAfterBet)
    }
}
