//
//  SignInView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = UserViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showsSignUp: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("hintergrundlogin")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    // Titel "Login"
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 40)

                    TextField("Email eingeben ...", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal, 40)

                    SecureField("Passwort", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)

                    // Login Button
                    Button(action: {
                        viewModel.signIn(email: email, password: password)
                    }) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }

                    // Registrierung Button
                    HStack {
                        Text("Noch keinen Account?")
                            .foregroundColor(.black)

                        Button(action: {
                            showsSignUp = true
                        }) {
                            Text("Hier Registrieren!")
                                .foregroundColor(.red)
                                .underline()
                        }
                    }
                    .padding(.top, 20)

                    // Social Login Buttons (Google, Facebook)
                    HStack(spacing: 20) {
                        Button(action: {
                            // Google Login Logik
                        }) {
                            Text("GOOGLE")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            // Facebook Login Logik
                        }) {
                            Text("FACEBOOK")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 20)

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showsSignUp) {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginView()
}
