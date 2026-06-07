//
//  PreviewSupport.swift
//  Sports-Almanach
//
//  Central scaffolding for Xcode Canvas previews. Everything here is DEBUG-only
//  and lives under "Preview Content" (a development-assets path), so it never
//  ships in a release build.
//
//  Why this exists:
//  The ViewModels resolve their repositories from `AppContainer.shared`, which
//  wires up Firebase. A preview must NOT touch Firebase (it would need
//  `FirebaseApp.configure()` and a network) — so we inject in-memory mocks that
//  serve the existing `Mocks` fixtures. One `.previewEnvironment()` modifier
//  then assembles a fully populated, authenticated environment for any view.
//

#if DEBUG
import SwiftUI

// MARK: - Shared preview identity

enum PreviewData {
    static let user = SportsAlmanachUser(id: "user1", email: "max@example.com")
}

// MARK: - In-memory mock services (no Firebase, no network)

final class PreviewAuthService: AuthServiceProtocol, @unchecked Sendable {
    private let user: SportsAlmanachUser
    init(user: SportsAlmanachUser = PreviewData.user) { self.user = user }

    var currentUser: SportsAlmanachUser? { user }

    func userStream() -> AsyncStream<SportsAlmanachUser?> {
        AsyncStream { continuation in
            continuation.yield(user)
            continuation.finish()
        }
    }

    func signUp(email: String, password: String) async throws -> SportsAlmanachUser { user }
    func signIn(email: String, password: String) async throws -> SportsAlmanachUser { user }
    func signOut() throws {}
}

final class PreviewProfileRepository: ProfileRepositoryProtocol, @unchecked Sendable {
    func createProfile(_ profile: Profile) async throws {}
    func loadProfile(userID: String) async throws -> Profile? {
        Mocks.profiles.first { $0.id == userID } ?? Mocks.profiles.first
    }
    func loadAllProfiles() async throws -> [Profile] { Mocks.profiles }
    func updateBalance(userID: String, newBalance: Money) async throws {}
    func updateLastBirthdayBonusYear(userID: String, year: Int) async throws {}
}

final class PreviewEventRepository: EventRepositoryProtocol, @unchecked Sendable {
    func fetchEvents(league: League, season: Season) async throws -> [Event] { Mocks.events }
    func fetchEvent(id eventID: String) async throws -> Event? {
        Mocks.events.first { $0.id == eventID }
    }
    func persistSelectedEvent(_ event: Event, forUser userID: String) async throws {}
    func removeSelectedEvent(eventID: String, forUser userID: String) async throws {}
    func loadSelectedEvents(forUser userID: String) async throws -> [Event] {
        Array(Mocks.events.prefix(2))
    }
}

final class PreviewBetRepository: BetRepositoryProtocol, @unchecked Sendable {
    func placeSlip(_ slip: BetSlip, debiting stake: Money, from userID: String) async throws {}
    func loadSlips(userID: String) async throws -> [BetSlip] { Mocks.betSlips }
    func loadPendingSlips(userID: String) async throws -> [BetSlip] { [] }
    func settleSlip(_ slip: BetSlip, creditingTo userID: String) async throws {}
    func nextSlipNumber(forUser userID: String) async throws -> Int { Mocks.betSlips.count + 1 }
}

enum PreviewServices {
    static func bettingService() -> BettingService {
        BettingService(betRepository: PreviewBetRepository(),
                       profileRepository: PreviewProfileRepository())
    }
}

// MARK: - One-line environment for any view

extension View {
    /// Wraps a view in a fully populated, authenticated preview environment:
    /// session + all three ViewModels (seeded with `Mocks`), dark mode and the
    /// brand tint. Use in any `#Preview`.
    @MainActor
    func previewEnvironment() -> some View {
        let session = AppSession.preview()
        return self
            .environmentObject(session)
            .environmentObject(UserViewModel.preview(session: session))
            .environmentObject(EventViewModel.preview(session: session))
            .environmentObject(BetViewModel.preview(session: session))
            .preferredColorScheme(.dark)
            .tint(AppTheme.Colors.accent)
    }
}
#endif
