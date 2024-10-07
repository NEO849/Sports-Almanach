//
//  RegisterView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false
    @State private var showErrorAlert: Bool = false
    @Environment(\.presentationMode) var backToLogin
    @State private var navigateToContentView: Bool = false
    @State private var birthday: Date = Date()  // Date statt String
    @State private var selectedNumber: Int = 18
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("Registrieren")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                    
                    ZStack(alignment: .leading) {
                        if username.isEmpty {
                            Text("Benutzername eingeben")
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 12)
                        }
                        TextField("", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white.opacity(0.8))
                            .cornerRadius(10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                    }
                    .padding()
                    
                    ZStack(alignment: .leading) {
                        if email.isEmpty {
                            Text("Email ...")
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 12)
                        }
                        TextField("", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white.opacity(0.8))
                            .cornerRadius(10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 20)
                    
                    // Passwort
                    HStack {
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("Passwort ...")
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.leading, 12)
                            }
                            if isPasswordVisible {
                                TextField("", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            } else {
                                SecureField("", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(isPasswordVisible ? .green : .red)
                            }
                            .padding(.leading, 248)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Wiederholung
                    HStack {
                        ZStack(alignment: .leading) {
                            if passwordRepeat.isEmpty {
                                Text("Wiederholen ...")
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.leading, 12)
                            }
                            if isRepeatPasswordVisible {
                                TextField("", text: $passwordRepeat)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            } else {
                                SecureField("", text: $passwordRepeat)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            }
                            
                            // Passwort Sichtbar
                            Button(action: {
                                isRepeatPasswordVisible.toggle()
                            }) {
                                Image(systemName: isRepeatPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(isRepeatPasswordVisible ? .green : .red)
                            }
                            .padding(.leading, 248)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Startgeld
                    ZStack(alignment: .leading) {
                        Text("Startgeld:")
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 12)
                        TextField("1000.00 €", text: .constant("1000.00 €"))
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white.opacity(0.8))
                            .cornerRadius(10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                            .disabled(true) // Deaktiviert Textfeld
                    }
                    .padding()
                    
                    // Geburtsdatum
                    Menu {
                        ForEach(18..<100) { number in
                            Button(action: {
                                selectedNumber = number
                            }) {
                                Text("\(number)")
                            }
                        }
                    } label: {
                        Text("Geburtsdatum: \(selectedNumber)")
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                    }
                    .frame(width: 300, height: 50)
                    .padding()
                    
                    // Registrieren Button
                    Button(action: {
                        userViewModel.signUp(
                            username: username,
                            email: email,
                            password: password,
                            passwordRepeat: passwordRepeat,
                            birthday: Calendar.current.date(byAdding: .year, value: -selectedNumber, to: Date()) ?? Date()
                        )
                        
                        // Falls die Registrierung erfolgreich ist, navigiere weiter
                        if userViewModel.isRegistered {
                            navigateToContentView = true
                        } else {
                            showErrorAlert = true
                        }
                    }) {
                        Text("REGISTRIEREN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.orange.opacity(0.9))
                            .cornerRadius(10)
                    }
                    .padding(.top, 32)
                    
                    // Zurück zur LoginView
                    Button(action: {
                        navigateToContentView = false
                    }) {
                        Text("Zurück zur Anmeldung")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.top, 32)
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(userViewModel.errorMessage ?? "Unbekannter Fehler"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView()
                    .environmentObject(userViewModel)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}


#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}

