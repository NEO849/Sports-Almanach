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

    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            userViewModel.logout()  // Logout func
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    Text("HomeView")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.clear)
                        .contentShape(Rectangle())
                }
            }
            .navigationBarBackButtonHidden(true)
            .onReceive(userViewModel.$isLoggedIn) { isLoggedIn in
                           if !isLoggedIn {
                               navigateToLogin = true  // Bei Abmeldung
                           }
                       }
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()  // Zur Login
                }
            }
        }
    }

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
