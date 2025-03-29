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
        setupAuthStateListener()
        setupBirthdayCheck()
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
    /// Lädt das Benutzerprofil aus Firebase
    /// Setzt auch den Geburtstag für die Bonus-Überprüfung
    func loadUserProfile() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            if let profile = try await profileRepo.loadProfile(userId: userId) {
                userState.profile = profile
                userState.balance = profile.balance
                // Geburtstag als Timestamp setzen
                userState.birthday = Timestamp(date: profile.birthday)
                print("✅ Profil geladen mit Geburtstag: \(profile.birthday)")
            } else {
                print("❌ Fehler beim Laden des Profils")
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
    
    // MARK: - Birthday Handling
    /// Initiiert die tägliche Geburtstags-Überprüfung
    func setupBirthdayCheck() {
        BirthdayUtils.scheduleDailyBirthdayCheck(for: self)
    }
    
    func resetBalance() {
        print("Reset Balance aufgerufen. Aktueller Kontostand: \(userState.balance)")
        if userState.balance <= 0 {
            print("Kontostand ist 0 oder kleiner, setze auf Standardwert")
            userState.balance = Constants.defaultStartMoney
            // Zuerst in Firebase speichern
            Task {
                await MainActor.run {
                    updateProfile(newBalance: Constants.defaultStartMoney)
                }
            }
        }
    }
    
    /// Zentrale Methode für Kontostandänderungen
    func updateBalance(amount: Double, type: TransactionType) {
        let newBalance = userState.balance + amount
        if newBalance <= 0 {
            resetBalance()
            return
        }
        // Kontostand aktualisieren und in Firestore speichern
        userState.balance = newBalance
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        Task {
            do {
                try await profileRepo.updateBalance(userId: userId, newBalance: newBalance)
                print("💰 \(type.rawValue): \(amount)€ → Neuer Kontostand: \(newBalance)€")
            } catch {
                print("❌ Fehler beim Aktualisieren des Kontostands: \(error)")
            }
        }
    }
    
    // Transaktionsarten
    enum TransactionType: String {
        case bet = "Wetteinsatz"
        case win = "Wettgewinn"
        case birthdayBonus = "Geburtstagsbonus"
        case reset = "Kontostand Reset"
    }
    
    // MARK: - Private Methods
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
    struct AuthState {
        var isLoading = false
        var isLoggedIn = false
        var isRegistered = false
        var showError = false
        var errorMessage: String?
        var errorMessages: [AppErrors.User] = []
    }
    
    /// Model for user state
    struct UserState {
        var profile: Profile?
        var balance: Double = Constants.defaultStartMoney
        var birthday: Timestamp?
    }
    
    // MARK: - Constants
    /// Starting money for new users
    /// - Central definition of default values
    private enum Constants {
        static let defaultStartMoney: Double = 1000.00
    }
}
