//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Entry point. Wires the composition root (`AppContainer`), the observable
//  `AppSession`, and the three top-level ViewModels, then routes based on
//  the live session phase rather than a snapshotted bool.
//

import SwiftUI
import Firebase

@main
struct Sports_AlmanachApp: App {

    // Single source of truth for auth — driven by the auth-state stream.
    @StateObject private var session: AppSession

    // ViewModels live for the whole app lifecycle, but ride on the session
    // so they can react when the user signs in or out.
    @StateObject private var userVM: UserViewModel
    @StateObject private var eventVM: EventViewModel
    @StateObject private var betVM: BetViewModel

    init() {
        FirebaseApp.configure()
        AppTheme.configureUIKitAppearance()
        let session = AppSession(authService: AppContainer.shared.authService())
        _session = StateObject(wrappedValue: session)
        _userVM = StateObject(wrappedValue: UserViewModel(session: session))
        _eventVM = StateObject(wrappedValue: EventViewModel(session: session))
        _betVM = StateObject(wrappedValue: BetViewModel(session: session))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .environmentObject(userVM)
                .environmentObject(eventVM)
                .environmentObject(betVM)
                .preferredColorScheme(.dark)   // brand identity is darkroom-first
                .task(id: session.phase) {
                    await reactToSessionChange()
                }
        }
    }

    private func reactToSessionChange() async {
        switch session.phase {
        case .authenticated(let user):
            await userVM.didAuthenticate(user)
            await eventVM.didAuthenticate(user)
            await betVM.didAuthenticate(user)
        case .unauthenticated:
            userVM.didSignOut()
            eventVM.didSignOut()
            betVM.didSignOut()
        case .bootstrapping:
            break
        }
    }
}
