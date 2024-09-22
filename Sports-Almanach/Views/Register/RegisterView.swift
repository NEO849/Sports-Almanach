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
    @State private var birthdate: Date = Date()  // Date statt String
    
    var body: some View {
        NavigationView {
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
                    
                    TextField("Benutzername", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding(.horizontal, 40)
                    
                    TextField("Email", text: $email)
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
                    
                    SecureField("Passwort wiederholen", text: $passwordRepeat)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                    
                    TextField("Startgeld", text: $startMoney)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal, 40)
                    
                    // Berechnung des maximalen Datums (heute)
                    let today = Date()
                    
                    // Mit Einschränkung auf Daten in der Vergangenheit
                    DatePicker("Geburtsdatum", selection: $birthdate, in: ...today, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    
                    // Registrieren
                    Button(action: {
                        if let startMoneyDouble = Double(startMoney) {
                            userViewModel.signUp(username: username, email: email, password: password, passwordRepeat: passwordRepeat, amount: startMoneyDouble, birthdate: birthdate)
                        }
                    }, label: {
                        Text("REGISTRIEREN")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    })
                    
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
