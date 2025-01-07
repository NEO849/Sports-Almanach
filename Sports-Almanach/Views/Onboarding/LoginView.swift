//
//  LogInView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//
//
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var animationOffset: CGFloat = 300
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 48) {
                        Title(title: "Anmelden")
                            .padding(.bottom, 62)
                            .offset(y: animationOffset)
                            .onAppear {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    animationOffset = 0
                                }
                            }
                        
                        // Input Field Groups
                        VStack(spacing: 20) {
                            InputField(
                                placeholder: "Email eingeben",
                                isSecure: false,
                                icon: "envelope",
                                text: $email,
                                isPasswordVisible: $isPasswordVisible
                            )
                            
                            InputField(
                                placeholder: "Passwort",
                                isSecure: true,
                                icon: "lock",
                                text: $password,
                                isPasswordVisible: $isPasswordVisible
                            )
                        }
                        .padding(.bottom, 36)
                        
                        // Login
                        LoginRegButton(title: "LOGIN") {
                            Task {
                                await userViewModel.login(email: email, password: password)
                            }
                        }
                        
                        // Registration Link
                        HStack {
                            Text("Noch keinen Account?")
                                .foregroundColor(.white)
                            NavigationLink(destination: RegisterView()) {
                                Text("Hier Registrieren!")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                        .padding(.bottom, 80)
                        
                        // Social Buttons
                        HStack(spacing: 34) {
                            SocialLoginButton(title: "Google", icon: "g.circle.fill", platform: .google) {
                                // Implement Google Logic
                
                            }
                            SocialLoginButton(title: "Facebook", icon: "f.circle.fill", platform: .facebook) {
                                // Implement Facebook Logic
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .ignoresSafeArea(.keyboard)
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $userViewModel.showError) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(userViewModel.errorMessage ?? "Unbekannter Fehler"),
                    dismissButton: .default(Text("OK")) {
                        // Only Password Reset
                        password = ""
                    }
                )
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
