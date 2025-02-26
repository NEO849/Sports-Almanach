//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI
import Firebase

/// Marks this as the application's entry point
@main
struct Sports_AlmanachApp: App {

    // Initialize Firebase when app starts
    init() {
          FirebaseApp.configure()
      }
    
    // These ViewModels will be available throughout the entire app lifecycle
    @StateObject private var betViewModel = BetViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventViewModel = EventViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Route to different views based on authentication status
            Group {
                if FirebaseAuthManager.shared.isUserSignedIn {
                    ContentView()
                } else {
                    SplashView()
                }
            }
            // Inject ViewModels into the environment for child views to access
            .environmentObject(betViewModel)
            .environmentObject(userViewModel)
            .environmentObject(eventViewModel)
        }
    }
}
