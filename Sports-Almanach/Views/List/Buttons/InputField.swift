//
//  InputField.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 18.11.24.
//

import SwiftUI

struct InputField: View {
    let placeholder: String
    let isSecure: Bool
    let icon: String
    @Binding var text: String
    @Binding var isPasswordVisible: Bool
    @State private var isTextEntered = false
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            // Platzhaltertext
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(isTextEntered ? .white : .white.opacity(0.8)) // Dynamische Farbe
                    .padding(.leading, 52)
            }
            
            // Textfeld oder SecureField
            Group {
                if isSecure && !isPasswordVisible {
                    SecureField("", text: $text)
                        .textContentType(.password)
                        .textContentType(.oneTimeCode)
                        .autocorrectionDisabled(true)
                } else {
                    TextField("", text: $text)
                        .textContentType(.oneTimeCode)
                        .autocorrectionDisabled(true)
                }
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isTextEntered ? .black.opacity(0.4) : .gray.opacity(0.2))
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // Icon für das Textfeld
            Image(systemName: icon)
                .foregroundColor(isTextEntered ? .white : .white.opacity(0.8))
                .frame(width: 24, height: 24)
                .padding(.leading, 12)
            
            // Augen-Icon für Passwortsichtbarkeit
            if isSecure {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isPasswordVisible.toggle()
                    }
                }) {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundColor(isPasswordVisible ? .green : .red)
                        .frame(width: 24, height: 24)
                }
                .padding(.leading, 256)
            }
        }
        .frame(width: 300, height: 50)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.orange, lineWidth: 1)
        )
    }
}

#Preview {
    @Previewable @State var password: String = ""
    @Previewable @State var isPasswordVisible: Bool = false
    
    ZStack {
        Image("hintergrund")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)

        InputField(
            placeholder: "Passwort eingeben",
            isSecure: true,
            icon: "lock",
            text: $password,
            isPasswordVisible: $isPasswordVisible
        )
        .padding()
        .border(.red, width: 1)
    }
}
