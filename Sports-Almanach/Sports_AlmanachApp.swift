//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI
import Firebase

// MARK: - AppDelegate für Firebase Setup
// AppDelegate übernimmt die Initialisierung von Firebase außerhalb des Main Actors
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Firebase Konfiguration in einem nicht-isolierten Kontext
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        return true
    }
}

@main
struct Sports_AlmanachApp: App {
    
    // App Delegate für besseres Lifecycle Management
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // StateObjects für SwiftUI State Management
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventViewModel = EventViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Ausgelagerte View-Logic für bessere Testbarkeit
            Group {
                if FirebaseAuthManager.shared.isUserSignedIn {
                    ContentView()
                } else {
                    SplashView()
                }
            }
            // Environment Objects für Dependency Injection
            .environmentObject(userViewModel)
            .environmentObject(eventViewModel)
        }
    }
}
