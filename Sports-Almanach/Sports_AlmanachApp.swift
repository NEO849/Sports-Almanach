//
//  Sports_AlmanachApp.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

@main
struct Sports_AlmanachApp: App {
    /// Instanzen
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventViewModel = EventViewModel()
    
    var body: some Scene {
        
        WindowGroup {
    
//            ContentView()
//                .environmentObject(userViewModel)
//                .environmentObject(eventViewModel) 
        }
    }
}
