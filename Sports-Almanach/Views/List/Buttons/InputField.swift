//
//  InputField.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 18.11.24.
//

import SwiftUI

/// The reusable component adapts its appearance and behavior based on the provided properties.
/// Parent-view controlled and local focus for UI effects.
struct InputField: View {
    let placeholder: String
    let isSecure: Bool
    let icon: String
    @Binding var text: String
    @Binding var isPasswordVisible: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Placeholder
            if text.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.leading, 52)
            }
            
            HStack(spacing: 12) {
                // Icon for Textfield
                Image(systemName: icon)
                    .foregroundColor(isFocused || !text.isEmpty ? .white : .white.opacity(0.8))
                    .frame(width: 24, height: 24)
                
                // Textfield or Securefield
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text)
                            .autocorrectionDisabled(true)
                            .focused($isFocused)
                    } else {
                        TextField("", text: $text)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .focused($isFocused)
                    }
                }
                
                // Eye Icon for Passwordvisibility
                if isSecure {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? .green : .red)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isFocused || !text.isEmpty ? .black.opacity(0.4) : .gray.opacity(0.2))
            )
            .foregroundColor(.white)
            .cornerRadius(10)
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
