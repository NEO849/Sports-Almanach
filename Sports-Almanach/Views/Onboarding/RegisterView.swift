//
//  RegisterView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct RegisterView: View {
    
    // Source of truth
    @EnvironmentObject var userViewModel: UserViewModel
    
    // Benutzereingaben
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    
    // Status Passwortsichtbarkeit
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false
    
    // Fehlerbehandlungen
    @State private var showErrorAlert: Bool = false
    
    // Navigation
    @State private var navigateToContentView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    // Geburtstag
    @State private var birthday: Date = Date()
    
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
                    
                    HStack {
                        Text("Startgeld:")
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 12)
                        Spacer()
                        Text(String(format: "%.2f €    ", userViewModel.startMoney))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                    .padding(.bottom, 20)
                    
                    // Geburtstag mit DatePicker
                    HStack {
                        Text("Geburtsdatum:")
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 12)
                        Spacer()

                        DatePicker("", selection: $birthday, displayedComponents: .date)
                            //.labelsHidden()  
                            .datePickerStyle(CompactDatePickerStyle())
                            .frame(width: 150)
                    }
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                    .padding(.bottom, 20)
                    
                    // Registrieren
                    Button(action: {
                        userViewModel.signUp(
                            username: username,
                            email: email,
                            password: password,
                            passwordRepeat: passwordRepeat,
                            birthday: birthday // Übergabe des gewählten Datums
                        )
                        
                        // Falls erfolgreich , navigi. -> ContentView
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
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Schließt aktuelle View -> LoginView
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
            .navigationBarBackButtonHidden(true) // Entfernt Back-Button aktuellen View
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView()
                    .environmentObject(userViewModel)
                    .navigationBarBackButtonHidden(true) // Entfernt Back-Button ContentView
            }
        }
    }
}


#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}

