//
//  LogInView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false 
    @State private var showRegisterView: Bool = false
    @State private var showContentView: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("hintergrundlogin")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    
                    // E-Mail-Adresse
                    TextField("Email eingeben ...", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50)  // Feste Breite und Höhe
                        .padding(.bottom, 20)
                    
                    // Passwortfeld mit Sichtbarkeitsumschaltung
                    ZStack {
                        if isPasswordVisible {
                            TextField("Passwort", text: $password)  // Normales Textfeld, wenn sichtbar
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: 300, height: 50)  // Feste Breite und Höhe
                        } else {
                            SecureField("Passwort", text: $password)  // Sichere Eingabe, wenn nicht sichtbar
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: 300, height: 50)  // Feste Breite und Höhe
                        }
                        
                        // Umschaltbutton für Passwortsichtbarkeit
                        HStack {
                            Spacer()
                            Button(action: {
                                isPasswordVisible.toggle()  // Sichtbarkeit umschalten
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(isPasswordVisible ? .green : .gray)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Login Button
                    Button(action: {
                        userViewModel.signIn(email: email, password: password)
                        if userViewModel.isLoggedIn {
                            showContentView = true
                        }
                    }) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 50)  // Feste Breite und Höhe
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                    }
                    
                    // Fehlernachricht
                    if let errorMessage = userViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                    
                    HStack {
                        Text("Noch keinen Account?")
                            .foregroundColor(.black)
                        
                        Button(action: {
                            showRegisterView = true
                        }) {
                            Text("Hier Registrieren!")
                                .foregroundColor(.red)
                                .underline()
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            
            .navigationDestination(isPresented: $showContentView) {
                ContentView()
                    .environmentObject(userViewModel)
            }
            
            .navigationDestination(isPresented: $showRegisterView) {
                RegisterView()
                    .environmentObject(userViewModel)
            }
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
