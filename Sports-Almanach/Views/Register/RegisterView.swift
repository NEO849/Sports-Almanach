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
    @State private var startMoney: String = ""
    @State private var birthdate: Date = Date()
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrundlogin")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Registrieren")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    
                    // Benutzername
                    TextField("Benutzername", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50)
                        .padding(.bottom, 20)
                    
                    // E-Mail
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .frame(width: 300, height: 50)
                        .padding(.bottom, 20)
                    
                    // Passwort
                    ZStack {
                        if isPasswordVisible {
                            TextField("Passwort", text: $password)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: 300, height: 50)
                        } else {
                            SecureField("Passwort", text: $password)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: 300, height: 50)
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(isPasswordVisible ? .green : .gray)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Passwort Wiederholung
                    ZStack {
                        if isRepeatPasswordVisible {
                            TextField("Passwort wiederholen", text: $passwordRepeat)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: 300, height: 50)
                        } else {
                            SecureField("Passwort wiederholen", text: $passwordRepeat)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: 300, height: 50)
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                isRepeatPasswordVisible.toggle()
                            }) {
                                Image(systemName: isRepeatPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(isRepeatPasswordVisible ? .green : .gray)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Startgeld
                    TextField("Startgeld", text: $startMoney)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.decimalPad)
                        .frame(width: 300, height: 50)
                        .padding(.bottom, 20)
                    
                    // Geburtsdatum
                    DatePicker("Geburtsdatum", selection: $birthdate, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    
                    // Registrieren Button
                    Button(action: {
                        if let startMoneyDouble = Double(startMoney) {
                            userViewModel.signUp(username: username, email: email, password: password, passwordRepeat: passwordRepeat, amount: startMoneyDouble, birthdate: birthdate)
                        }
                    }) {
                        Text("REGISTRIEREN")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 50)
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                    }
                    
                    // Fehlernachricht
                    if let errorMessage = userViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}

