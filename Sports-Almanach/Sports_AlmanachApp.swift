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
    
    @StateObject var userViewModel = UserViewModel()
    @StateObject var eventViewModel = EventViewModel()
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if FirebaseAuthManager.shared.isUserSignedIn {
                ContentView()
                    .environmentObject(userViewModel)
                    .environmentObject(eventViewModel)
            } else {
                SplashView()
                    .environmentObject(userViewModel)
                    .environmentObject(eventViewModel)
            }
            
        }
    }
}
