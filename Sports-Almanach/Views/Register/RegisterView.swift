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
    @State private var age: String = ""

    var body: some View {
        VStack {
            TextField("Benutzername", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Passwort", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Passwort wiederholen", text: $passwordRepeat)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Startgeld", text: $startMoney)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Alter", text: $age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Registrieren") {
                if let startMoneyDouble = Double(startMoney), let ageInt = Int(age) {
                    userViewModel.signUp(username: username, email: email, password: password, passwordRepeat: password, amount: startMoneyDouble, age: ageInt)
                }
            }
            .padding()
        }
        .navigationTitle("Registrieren")
    }
}

#Preview {
    RegisterView()
        .environmentObject(UserViewModel()) 
}
