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
    
    var body: some Scene {
        WindowGroup {
            // Übergabe der ViewModels an die ContentView
            ContentView()
                .environmentObject(userViewModel) // ViewModel für Benutzerdaten
                .environmentObject(eventViewModel) // ViewModel für Ereignisdaten
        }
    }
}
