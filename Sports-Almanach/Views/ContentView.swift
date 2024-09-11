//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

//struct ContentView: View {
//    @EnvironmentObject var userViewModel: UserViewModel // Zugriff auf das UserViewModel
//
//    var body: some View {
//        NavigationStack {
//            // Überprüft, ob der Benutzer eingeloggt ist
//            if userViewModel.isAuthenticated {
//                // Wenn eingeloggt, zeigt die Hauptansicht mit Tabs
//                MainTabView()
//            } else {
//                // Wenn nicht eingeloggt, zeigt die Anmelde- und Registrierungsansichten
//                VStack {
//                    NavigationLink(destination: SignInView()) {
//                        Text("Anmelden")
//                            .padding()
//                    }
//                    
//                    NavigationLink(destination: SignUpView()) {
//                        Text("Registrieren")
//                            .padding()
//                    }
//                }
//                .navigationTitle("Willkommen")
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(UserViewModel()) 
//        .environmentObject(EventViewModel())
//}
