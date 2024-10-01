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
    @State private var startMoney: String = ""
    @State private var birthdate: Date = Date()  // Date statt String
    @Environment(\.presentationMode) var backToLogin
    
    
    var body: some View {
        
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
                        
                        // In Klartext anzeigen
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
                
                // Spielgeld
                ZStack(alignment: .leading) {
                    if startMoney.isEmpty {
                        Text("Spielgeld Betrag ...")
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 12)
                    }
                    TextField("", text: $startMoney)
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
                
                // Geburtsdatum
                DatePicker("", selection: $birthdate, displayedComponents: .date)
                    .labelsHidden()
                    .colorInvert()
                    .background(Color.black)
                    .padding()
                
                
                // Registrieren
                Button(action: {
                    if let startMoneyDouble = Double(startMoney) {
                        userViewModel.signUp(username: username, email: email, password: password, passwordRepeat: passwordRepeat, amount: startMoneyDouble, birthdate: birthdate)
                        if let errorMessage = userViewModel.errorMessage {
                            print("Fehlermeldung: \(errorMessage)")
                            showErrorAlert = true
                        }
                    } else {
                        print("Ungültiger Spielgeldbetrag.")
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
                
                // Zur LoginView
                Button(action: {
                    backToLogin.wrappedValue.dismiss()
                }) {
                    Text("Zurück zur Anmeldung")
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.top, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Fehler"), message: Text(userViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}

