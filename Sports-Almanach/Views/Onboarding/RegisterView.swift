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
     @State private var startMoney: String = ""
     @State private var birthdate: Date = Date()  // Date statt String
     @Environment(\.presentationMode) var presentationMode
     @State private var showErrorAlert: Bool = false

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

                 TextField("Benutzername", text: $username)
                     .padding()
                     .background(Color.gray.opacity(0.2))
                     .foregroundColor(.white.opacity(0.8))
                     .cornerRadius(10)
                     .frame(width: 300, height: 50)
                     .overlay(
                         RoundedRectangle(cornerRadius: 10)
                             .stroke(Color.orange, lineWidth: 2)
                     )
                     .padding()

                 TextField("Email", text: $email)
                     .padding()
                     .background(Color.gray.opacity(0.2))
                     .foregroundColor(.white.opacity(0.8))
                     .cornerRadius(10)
                     .frame(width: 300, height: 50)
                     .overlay(
                         RoundedRectangle(cornerRadius: 10)
                             .stroke(Color.orange, lineWidth: 2)
                     )
                     .padding()

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
                             .background(Color.gray.opacity(0.2))
                             .foregroundColor(.white.opacity(0.8))
                             .cornerRadius(10)
                             .frame(width: 300, height: 50)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.orange, lineWidth: 2)
                             )
                             .padding()
                     }

                     HStack {
                         Spacer()
                         Button(action: {
                             isPasswordVisible.toggle()
                         }) {
                             Label("", systemImage: isPasswordVisible ? "eye" : "eye.slash")
                                 .foregroundColor(isPasswordVisible ? .green : .red)
                         }
                         .padding(.trailing, 86)
                     }
                 }
                 .padding(.bottom, 28)

                 // Passwort Wiederholung
                 ZStack {
                     if isRepeatPasswordVisible {
                         TextField("Passwort wiederholen", text: $passwordRepeat)
                             .background(Color.gray.opacity(0.3))
                             .cornerRadius(10)
                             .foregroundColor(.black)
                             .frame(width: 300, height: 50)
                     } else {
                         SecureField("Passwort wiederholen", text: $passwordRepeat)
                             .background(Color.gray.opacity(0.2))
                             .foregroundColor(.white.opacity(0.8))
                             .cornerRadius(10)
                             .frame(width: 300, height: 50)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.orange, lineWidth: 2)
                             )
                     }

                     HStack {
                         Spacer()
                         Button(action: {
                             isRepeatPasswordVisible.toggle()
                         }) {
                             Label("", systemImage: isRepeatPasswordVisible ? "eye" : "eye.slash")
                                 .foregroundColor(isRepeatPasswordVisible ? .green : .red)
                         }
                         .padding(.trailing, 86)
                     }
                 }
                 .padding(.bottom, 28)

                 // Startgeld
                 TextField("Startgeld", text: $startMoney)
                     .background(Color.gray.opacity(0.2))
                     .foregroundColor(.white.opacity(0.8))
                     .cornerRadius(10)
                     .frame(width: 300, height: 50)
                     .overlay(
                         RoundedRectangle(cornerRadius: 10)
                             .stroke(Color.orange, lineWidth: 2)
                     )

                 // Geburtsdatum
                 DatePicker("Geburtsdatum", selection: $birthdate, displayedComponents: .date)
                     .labelsHidden()
                     .padding(.bottom, 28)

                 // Registrieren Button
                 Button(action: {
                     if let startMoneyDouble = Double(startMoney) {
                         userViewModel.signUp(username: username, email: email, password: password, passwordRepeat: passwordRepeat, amount: startMoneyDouble, birthdate: birthdate)
                         if let _ = userViewModel.errorMessage {
                             showErrorAlert = true
                         }
                     }
                 }) {
                     Text("REGISTRIEREN")
                         .font(.headline)
                         .foregroundColor(.white)
                         .frame(width: 300, height: 50)
                         .background(Color.orange.opacity(0.9))
                         .cornerRadius(10)
                 }

                 Button(action: {
                     presentationMode.wrappedValue.dismiss() // Zurück zur LoginView
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

