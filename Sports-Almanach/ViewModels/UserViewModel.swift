//
//  UserViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// ViewModel for managing user authentication and profile
/// Uses MVVM pattern to separate views from business logic
@MainActor
class UserViewModel: ObservableObject {
    
    @Published private(set) var authState = AuthState()
    @Published private(set) var userState = UserState()
    
    private let profileRepo: ProfileRepository
    // Auth State Listener Handle für Cleanup
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    
    init(profileRepo: ProfileRepository = ProfileRepository()) {
        self.profileRepo = profileRepo
        /// Schedule daily birthday check
        BirthdayUtils.dailyBirthdayCheck(for: self)
        setupAuthStateListener()
    }
    
    // MARK: - Login Function
    /// Logs in a user with email and password
    /// - Sets loading state and handles errors
    /// - Loads user profile on success
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
    /// - Validates inputs before saving
    /// - Checks for existing email addresses
    /// - Creates Firebase account and user profile
    func register(
        username: String,
        email: String, password: String,
        passwordRepeat: String,
        birthday: Date) async {
            authState.isLoading = true
            defer { authState.isLoading = false }
            
            // Validation of all input fields against defined rules
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
            
            // Email check against duplicates in the database
            if await emailAlreadyExists(email: email) {
                authState.errorMessages = [AppErrors.User.emailAlreadyExists]
                return
            }
            
            do {
                // Firebase registration through AuthManager
                try await FirebaseAuthManager.shared.signUp(email: email, password: password)
                
                guard let userId = FirebaseAuthManager.shared.userID else {
                    authState.errorMessage = AppErrors.User.userNotFound.errorDescriptionGerman
                    return
                }
                
                // Create new profile with starting balance
                let newProfile = Profile(
                    id: UUID().uuidString,
                    name: username,
                    email: email,
                    birthday: birthday,
                    startMoney: Constants.defaultStartMoney,
                    balance: Constants.defaultStartMoney
                )
                
                try await profileRepo.saveProfile(newProfile, userId: userId)
                authState.isRegistered = true
                await loadUserProfile()
            } catch {
                handleAuthError(error)
            }
        }
    
    // MARK: - Logout Function
    /// Logs out the user and resets ViewModels
    /// - Important: Resets both auth and user state
    func logout() {
        FirebaseAuthManager.shared.signOut()
        resetState()
    }
    
    // MARK: - Load Profile
    /// Loads the user profile from Firebase
    /// - Essential for initialization after login and for updates
    func loadUserProfile() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            if let profile = try await profileRepo.loadProfile(userId: userId) {
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
    /// Checks if an email address already exists in the database
    /// - Parameter email: Email address to check
    /// - Returns: True if the email already exists
    func emailAlreadyExists(email: String) async -> Bool {
        do {
            return try await profileRepo.emailExists(email)
        } catch {
            print("Fehler beim Überprüfen der Email: \(error)")
            return false
        }
    }
    
    // MARK: - Update Profile
    /// Updates user balance in the database and local state
    /// - Parameter newBalance: The new account balance
    func updateProfile(newBalance: Double) {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        Task {
            do {
                try await profileRepo.updateBalance(userId: userId, newBalance: newBalance)
                await MainActor.run {
                    userState.balance = newBalance
                }
            } catch {
                print("Fehler beim Aktualisieren des Kontostands: \(error)")
            }
        }
    }
    
    func updateMoneyUserBirthday() {
        guard let userId = FirebaseAuthManager.shared.userID, let birthday = userState.birthday else {
            print("Fehler: Benutzer-ID oder Geburtstag fehlt.")
            return
        }
        BirthdayUtils.checkBirthday(userId: userId, birthday: birthday)
    }
    
    func resetBalance() {
        print("Reset Balance aufgerufen. Aktueller Kontostand: \(userState.balance)")
        if userState.balance <= 0 {
            print("Kontostand ist 0 oder kleiner, setze auf Standardwert")
            userState.balance = Constants.defaultStartMoney
            // Wichtig: Zuerst in Firebase speichern
            Task {
                await MainActor.run {
                    updateProfile(newBalance: Constants.defaultStartMoney)
                }
            }
        }
    }
    
    func updateBalance(newBalanceAfterBet: Double) {
        print("Update Balance aufgerufen. Neuer Kontostand: \(newBalanceAfterBet)")
        userState.balance = newBalanceAfterBet
        // Prüfe und setze zurück wenn nötig
        if userState.balance <= 0 {
            resetBalance()
        } else {
            // Nur updaten wenn nicht zurückgesetzt wurde
            updateProfile(newBalance: newBalanceAfterBet)
        }
    }
    
    // MARK: - Private Methods
    /// Processes Firebase authentication errors and sets appropriate error messages
    /// - Converts Firebase error codes to user-friendly messages
    private func handleAuthError(_ error: Error) {
        if let authError = error as? AuthErrorCode {
            switch authError.code {
            case .emailAlreadyInUse:
                authState.errorMessage = AppErrors.User.emailAlreadyExists.errorDescriptionGerman
            case .invalidEmail:
                authState.errorMessage = AppErrors.User.invalidEmail.errorDescriptionGerman
            default:
                authState.errorMessage = AppErrors.User.unknownError.errorDescriptionGerman
            }
        }
        authState.showError = true
    }
    
    /// Resets all states to their default values
    /// - Used during logout to ensure clean state
    private func resetState() {
        authState = AuthState()
        userState = UserState()
    }

    /// Sets up a Firebase listener for authentication state changes
    /// - Uses weak self to avoid memory leaks
    private func setupAuthStateListener() {
        // Stores the Auth State Listener Handle for later cleanup
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

    /// Removes Firebase listeners when the class is deinitialized
    /// - Prevents memory leaks and unnecessary callback executions
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - State Structs
    /// Model for authentication state
    /// - Holds all auth-related flags and error messages
    struct AuthState {
        var isLoading = false
        var isLoggedIn = false
        var isRegistered = false
        var showError = false
        var errorMessage: String?
        var errorMessages: [AppErrors.User] = []
    }
    
    /// Model for user state
    /// - Contains profile data and current account information
    struct UserState {
        var profile: Profile?
        var balance: Double = Constants.defaultStartMoney
        var birthday: Timestamp?
    }
    
    // MARK: - Constants
    /// Constants for the application
    /// - Central definition of default values
    private enum Constants {
        // Starting money for new users
        static let defaultStartMoney: Double = 1000.00
    }
}
