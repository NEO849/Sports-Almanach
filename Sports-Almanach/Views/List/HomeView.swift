//
//  HomeView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var navigateToLogin: Bool = false
    
    let banner = [
        "Banner/bannersports",
        "Banner/basketball",
        "Banner/boxen",
        "Banner/fussball",
        "Banner/golf",
        "Banner/laufen",
        "Banner/radfahren",
        "Banner/schwimmen",
        "Banner/tennis"]
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        userViewModel.logout()  // Logout
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .padding()
                Spacer()
            }
            VStack {
                Image("appname")
                    .resizable()
                    .scaledToFit()
                Spacer()
                
                // Images im banner anzeigen
                // App Intro und Einführung
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: userViewModel.isLoggedIn) { isLoggedIn in
            if !isLoggedIn {
                navigateToLogin = true  // Bei Abmeldung zur Login
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()  // Zur Login
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
