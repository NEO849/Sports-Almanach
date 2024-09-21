//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

@main
struct Sports_AlmanachApp: App {
    /// Instanzen der VM
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventViewModel = EventViewModel()
    @StateObject private var splashViewModel = SplashViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(userViewModel)
                .environmentObject(eventViewModel)
                .environmentObject(splashViewModel)
        }
    }
}
