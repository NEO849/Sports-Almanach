//
//  UserViewModel.swift
//  Sports-Almanach
//
//  ViewModel for the authenticated user's profile + balance. Re-implemented
//  on top of AppSession (auth stream) and ProfileRepositoryProtocol (DI).
//
//  Key behavioural fixes vs the legacy implementation:
//
//  - The dual `errorMessage` / `errorMessages` fields are consolidated into a
//    single `formErrors` array. LoginView and RegisterView now share one path.
//  - `updateBalance` no longer mutates local state before the Firestore write
//    succeeds. The write happens first; the published balance is only updated
//    after the repository call returns.
//  - `loadAndSortRankedUsers` keeps the same surface but uses the protocol.
//  - Birthday-bonus logic moves to a separate, year-keyed mechanism so a
//    sign-out/sign-in within the same day can't double-credit a different user.
//

import Foundation
import SwiftUI

@MainActor
public final class UserViewModel: ObservableObject {

    // MARK: - Published state

    @Published public private(set) var profile: Profile?
    @Published public private(set) var balance: Money = AppConstants.Balances.startingBalance
    @Published public private(set) var rankedUsers: [Profile] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var formErrors: [AppErrors.User] = []
    @Published public private(set) var alertMessage: String?

    // MARK: - Dependencies

    private let profileRepository: ProfileRepositoryProtocol
    private let session: AppSession

    public init(session: AppSession,
                profileRepository: ProfileRepositoryProtocol = AppContainer.shared.profileRepository()) {
        self.profileRepository = profileRepository
        self.session = session
    }

    // MARK: - Lifecycle hooks driven by AppSession

    /// Call from the root view when phase flips to `.authenticated`.
    public func didAuthenticate(_ user: SportsAlmanachUser) async {
        await loadProfile(userID: user.id)
        await maybeCreditBirthdayBonus()
    }

    public func didSignOut() {
        profile = nil
        balance = AppConstants.Balances.startingBalance
        rankedUsers = []
        formErrors = []
        alertMessage = nil
    }

    // MARK: - Profile

    /// Registers a new account and creates the matching Firestore profile.
    public func register(username: String,
                         email: String,
                         password: String,
                         passwordRepeat: String,
                         birthday: Date) async {
        isLoading = true
        defer { isLoading = false }

        let errors = ValidationUtils.validateRegistrationInputs(
            username: username,
            email: email,
            password: password,
            passwordRepeat: passwordRepeat,
            birthday: birthday
        )
        if !errors.isEmpty {
            formErrors = errors
            return
        }

        let result = await session.signUp(email: email, password: password)
        switch result {
        case .failure(let error):
            handleAuthError(error)
        case .success(let user):
            let newProfile = Profile(
                id: user.id,
                username: username,
                email: email,
                birthday: birthday
            )
            do {
                try await profileRepository.createProfile(newProfile)
                profile = newProfile
                balance = newProfile.balance
            } catch {
                alertMessage = error.localizedDescription
            }
        }
    }

    /// Logs in via the AppSession (the auth stream will fire and trigger
    /// `didAuthenticate` from the root view).
    public func login(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        let result = await session.signIn(email: email, password: password)
        if case .failure(let error) = result {
            handleAuthError(error)
        }
    }

    /// Loads profile from Firestore — called after the auth stream flips on.
    public func loadProfile(userID: String) async {
        do {
            guard let loaded = try await profileRepository.loadProfile(userID: userID) else {
                AppLogger.warning("No profile document for \(userID)", category: .auth)
                return
            }
            profile = loaded
            balance = loaded.balance
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    /// Re-reads the profile from Firestore so the UI balance reflects
    /// server-side changes made by the betting transactions (stake debit on
    /// placement, win credit on settlement). The balance is debited/credited
    /// inside BetRepository's transactions, which this ViewModel doesn't observe
    /// directly — so call this after placing a slip and after settlement.
    public func refreshBalance() async {
        guard let userID = profile?.id ?? session.currentUser?.id else { return }
        await loadProfile(userID: userID)
    }

    /// Update the balance — Firestore first, then publish.
    @discardableResult
    public func setBalance(_ newBalance: Money) async -> Bool {
        guard let userID = profile?.id ?? session.currentUser?.id else { return false }
        do {
            try await profileRepository.updateBalance(userID: userID, newBalance: newBalance)
            balance = newBalance
            profile?.balance = newBalance
            return true
        } catch {
            AppLogger.error("Balance update failed: \(error.localizedDescription)", category: .repository)
            alertMessage = error.localizedDescription
            return false
        }
    }

    public func loadAndSortRankedUsers() async {
        do {
            let profiles = try await profileRepository.loadAllProfiles()
            rankedUsers = profiles.sorted { $0.balance > $1.balance }
        } catch {
            alertMessage = "Rangliste fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    public func logout() {
        session.signOut()
    }

    public func clearAlert() {
        alertMessage = nil
        formErrors = []
    }

    // MARK: - Birthday bonus
    // Year-keyed so the bonus credits at most once per calendar year per user,
    // regardless of sign-in cadence.
    private func maybeCreditBirthdayBonus() async {
        guard var profile else { return }
        let calendar = Calendar.current
        let today = Date()
        let yearToday = calendar.component(.year, from: today)

        // Same calendar day/month as DOB?
        let dob = calendar.dateComponents([.month, .day], from: profile.birthday)
        let now = calendar.dateComponents([.month, .day], from: today)
        guard dob.month == now.month, dob.day == now.day else { return }
        // Already credited this year?
        guard profile.lastBirthdayBonusYear != yearToday else { return }

        let newBalance = profile.balance + AppConstants.Balances.birthdayBonus
        do {
            try await profileRepository.updateBalance(userID: profile.id, newBalance: newBalance)
            try await profileRepository.updateLastBirthdayBonusYear(userID: profile.id, year: yearToday)
            profile.balance = newBalance
            profile.lastBirthdayBonusYear = yearToday
            self.profile = profile
            self.balance = newBalance
            AppLogger.info("Birthday bonus credited for \(profile.id)", category: .auth)
        } catch {
            AppLogger.warning("Birthday bonus failed: \(error.localizedDescription)", category: .auth)
        }
    }

    // MARK: - Error mapping

    private func handleAuthError(_ error: Error) {
        let nsError = error as NSError
        // FirebaseAuth uses a stable error code domain.
        switch nsError.code {
        case 17007: // ERROR_EMAIL_ALREADY_IN_USE
            formErrors = [.emailAlreadyExists]
        case 17008: // ERROR_INVALID_EMAIL
            formErrors = [.invalidEmail]
        case 17009, 17004: // ERROR_WRONG_PASSWORD / USER_NOT_FOUND
            alertMessage = AppErrors.User.emailOrPasswordInvalid.errorDescriptionGerman
        default:
            alertMessage = (error as? LocalizedError)?.errorDescription ?? AppErrors.User.unknownError.errorDescriptionGerman
        }
    }
}

#if DEBUG
extension UserViewModel {
    /// Pre-seeded ViewModel for Canvas previews (profile, balance, ranking).
    static func preview(session: AppSession,
                        profile: Profile? = Mocks.profiles.first,
                        ranked: [Profile] = Mocks.profiles) -> UserViewModel {
        let vm = UserViewModel(session: session, profileRepository: PreviewProfileRepository())
        vm.profile = profile
        vm.balance = profile?.balance ?? AppConstants.Balances.startingBalance
        vm.rankedUsers = ranked.sorted { $0.balance > $1.balance }
        return vm
    }
}
#endif
