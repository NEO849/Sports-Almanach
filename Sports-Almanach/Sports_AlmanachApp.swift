//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//  .

import SwiftUI
import Firebase

@main
struct Sports_AlmanachApp: App {
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if FirebaseAuthManager.shared.isUserSignedIn {
                ContentView()
            } else {
                SplashView()
            }
            
        }
    }
}
