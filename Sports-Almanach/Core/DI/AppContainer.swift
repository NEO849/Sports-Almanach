//
//  AppContainer.swift
//  Sports-Almanach
//
//  Lightweight composition root.
//
//  The legacy code instantiated `Firestore.firestore()` and concrete repositories
//  directly from inside ViewModels — that prevented tests from substituting
//  fakes and silently coupled every layer to Firebase. This container is the
//  single owner of those concrete types so call sites depend only on protocols.
//

import Foundation

/// Resolver protocol — kept small on purpose. We're not building a generic
/// dependency-injection framework, just a typed factory exposed to ViewModels.
public protocol DependencyResolver: AnyObject {
    func eventRepository() -> EventRepositoryProtocol
    func profileRepository() -> ProfileRepositoryProtocol
    func betRepository() -> BetRepositoryProtocol
    func bettingService() -> BettingService
    func authService() -> AuthServiceProtocol
}

public final class AppContainer: DependencyResolver {

    public static let shared: AppContainer = AppContainer()

    private init() {}

    // Lazy singletons — created on first request. Each one is stateless / thread-safe
    // (or wraps Firestore which manages its own concurrency).
    private lazy var _eventRepository: EventRepositoryProtocol = EventRepository()
    private lazy var _profileRepository: ProfileRepositoryProtocol = ProfileRepository()
    private lazy var _betRepository: BetRepositoryProtocol = BetRepository(eventRepository: _eventRepository)
    private lazy var _bettingService: BettingService = BettingService(
        betRepository: _betRepository,
        profileRepository: _profileRepository
    )
    private lazy var _authService: AuthServiceProtocol = FirebaseAuthService()

    public func eventRepository() -> EventRepositoryProtocol { _eventRepository }
    public func profileRepository() -> ProfileRepositoryProtocol { _profileRepository }
    public func betRepository() -> BetRepositoryProtocol { _betRepository }
    public func bettingService() -> BettingService { _bettingService }
    public func authService() -> AuthServiceProtocol { _authService }
}
