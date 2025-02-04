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
    
    @Published private(set) var authState = AuthState()
    @Published private(set) var userState = UserState()
    
    // FirestoreRepository
    private let fsRepository: FirestoreRepository
    // Auth State Listener Handle für Cleanup
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    
    init(repository: FirestoreRepository = FirestoreRepository()) {
        self.fsRepository = repository
        /// Tägliche Überprüfung des Geburtstags planen
        BirthdayUtils.dailyBirthdayCheck(for: self)
        setupAuthStateListener()
    }
    
    // MARK: - Login Function
    func login(email: String, password: String) async {
        authState.isLoading = true
        defer { authState.isLoading = false }
        
        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            authState.isLoggedIn = true
            await loadUserProfile()
        } catch {
            handleAuthError(error)
        }
    }
    
    // MARK: - Registration
    func register(
        username: String,
        email: String, password: String,
        passwordRepeat: String,
        birthday: Date) async {
            authState.isLoading = true
            defer { authState.isLoading = false }
            
            // Validierung
            let validationErrors = ValidationUtils.validateRegistrationInputs(
                username: username,
                email: email,
                password: password,
                passwordRepeat: passwordRepeat,
                birthday: birthday
            )
            
            if !validationErrors.isEmpty {
                authState.errorMessages = validationErrors
                return
            }
            
            // Email-Überprüfung
            if await emailAlreadyExists(email: email) {
                authState.errorMessages = [.emailAlreadyExists]
                return
            }
            
            do {
                // Firebase Anmeldung
                try await FirebaseAuthManager.shared.signUp(email: email, password: password)
                
                guard let userId = FirebaseAuthManager.shared.userID else {
                    authState.errorMessage = UserError.userNotFound.errorDescriptionGerman
                    return
                }
                
                let newProfile = Profile(
                    id: UUID().uuidString,
                    name: username,
                    email: email,
                    birthday: birthday,
                    startMoney: Constants.defaultStartMoney, // Hier geändert
                    balance: Constants.defaultStartMoney
                )
                
                try await fsRepository.saveProfile(newProfile, userId: userId)
                authState.isRegistered = true
                await loadUserProfile()
            } catch {
                handleAuthError(error)
            }
        }
    
    // MARK: - Logout Function
    func logout() {
        FirebaseAuthManager.shared.signOut()
        resetState()
    }
    
    // MARK: - Load Profile
    func loadUserProfile() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            if let profile = try await fsRepository.loadProfile(userId: userId) {
                userState.profile = profile
                userState.balance = profile.balance
            } else {
                print("Fehler beim Laden des Profils")
            }
        } catch {
            authState.errorMessage = error.localizedDescription
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
                    userState.balance = newBalance
                }
            } catch {
                print("Fehler beim Aktualisieren des Kontostands: \(error)")
            }
        }
    }
    
    // Birthday related functions remain the same
    func updateMoneyUserBirthday() {
        guard let userId = FirebaseAuthManager.shared.userID, let birthday = userState.birthday else {
            print("Fehler: Benutzer-ID oder Geburtstag fehlt.")
            return
        }
        BirthdayUtils.checkBirthday(userId: userId, birthday: birthday)
    }
    
    // Balance related functions remain the same
    func resetBalance() {
        if userState.balance == 0 {
            userState.balance = Constants.defaultStartMoney
                  updateProfile(newBalance: userState.balance)
              }
          }
    
    func updateBalance(newBalanceAfterBet: Double) {
        userState.balance = newBalanceAfterBet
        resetBalance()
        updateProfile(newBalance: newBalanceAfterBet)
    }
    
    // MARK: - Private Methods
    private func handleAuthError(_ error: Error) {
        if let authError = error as? AuthErrorCode {
            switch authError.code {
            case .emailAlreadyInUse:
                authState.errorMessage = UserError.emailAlreadyExists.errorDescriptionGerman
            case .invalidEmail:
                authState.errorMessage = UserError.invalidEmail.errorDescriptionGerman
            default:
                authState.errorMessage = UserError.unknownError.errorDescriptionGerman
            }
        }
        authState.showError = true
    }
    
    private func resetState() {
        authState = AuthState()
        userState = UserState()
    }
    
    private func setupAuthStateListener() {
        // Speichert den Auth State Listener Handle für späteres Cleanup
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] (_: Auth, user: User?) in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.authState.isLoggedIn = user != nil
                if user != nil {
                    await self.loadUserProfile()
                }
            }
        }
    }
    
    // Cleanup hinzufügen
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - State Structs
    struct AuthState {
        var isLoading = false
        var isLoggedIn = false
        var isRegistered = false
        var showError = false
        var errorMessage: String?
        var errorMessages: [UserError] = []
    }
    
    struct UserState {
        var profile: Profile?
        var balance: Double = Constants.defaultStartMoney
        var birthday: Timestamp?
    }
    
    // MARK: - Constants
    private enum Constants {
        // Startgeld für neue Benutzer
        static let defaultStartMoney: Double = 1000.00
    }
}
