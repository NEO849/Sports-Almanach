//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI
import Firebase

@main
struct Sports_AlmanachApp: App {
    
    init() {
          FirebaseApp.configure() 
      }
    
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
