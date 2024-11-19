//
//  LogInView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//
// Pudh
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var animationOffset: CGFloat = 300
    @State private var isPressed: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 48) {
                    Title(title: "Anmelden")
                        .padding(.bottom, 62)
                        .offset(y: animationOffset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                animationOffset = 0
                            }
                        }
                    
                    // Eingabe: Email und Passwort
                    InputField(
                        placeholder: "Email eingeben ...",
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
                    
                    // Login
                    LoginButton(title: "LOGIN") {
                        withAnimation(.spring()) {
                            isPressed.toggle()
                        }
                        attemptSignIn()
                    }
                    .scaleEffect(isPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.8), value: isPressed)
                    
                    // Registrierungshinweis
                    HStack {
                        Text("Noch keinen Account?")
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Hier Registrieren!")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    .padding(.bottom, 90)
                    
                    // Social Buttons
                    HStack(spacing: 24) {
                        SocialLoginButton(title: "Google", icon: "g.circle.fill", platform: .google, action: {
                            /// Google Logic
                        })
                        
                        SocialLoginButton(title: "Facebook", icon: "f.circle.fill", platform: .facebook, action: {
                            /// Facebook Logic
                        })
                    }
                    .padding(.bottom, 32)
                }
                .offset(y: animationOffset)
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $userViewModel.showError) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(userViewModel.errorMessage ?? "Unbekannter Fehler"),
                    dismissButton: .default(Text("OK")) {
                        // Reset
                        email = ""
                        password = ""
                        isPressed = false
                    }
                )
            }
        }
    }
    
    // Anmelden des Benutzers, Überprüfen der Eingaben
    private func attemptSignIn() {
        if email.isEmpty || password.isEmpty {
            userViewModel.errorMessage = UserError.emailOrPasswordInvalid.errorDescriptionGerman
            userViewModel.showError = true
            return
        }
        
        Task {
            do {
                // Versuch, den Benutzer anzumelden
                try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            } catch let error as UserError {
                // Spezifische und Unbekannter Fehler
                userViewModel.errorMessage = error.errorDescriptionGerman
                userViewModel.showError = true
            } catch {
                userViewModel.errorMessage = UserError.unknownError.errorDescriptionGerman
                userViewModel.showError = true
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
