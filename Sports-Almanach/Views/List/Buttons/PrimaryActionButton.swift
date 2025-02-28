//
//  LoginButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 18.11.24.
//

import SwiftUI

struct PrimaryActionButton: View {
    
    let title: String
    let action: () -> Void
    let isActive: Bool
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            if isActive {
                action()
                withAnimation(.spring()) {
                    isPressed.toggle()
                }
                isPressed = false
            }
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(
                    LinearGradient(
                        colors: isActive ? 
                            [.black, .orange.opacity(0.8)] : 
                            [.gray.opacity(0.6), .gray.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(10)
                .shadow(color: isActive ? .orange : .gray, radius: 4, x: -2, y: -2)
                .scaleEffect(isPressed ? 0.8 : 1.0)
        }
    }
}

#Preview {
    ZStack {
        Image("hintergrund")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
        
        PrimaryActionButton(
            title: "Login",
            action: {
                print("Button gedrückt")
            },
            isActive: true
        )
    }
}
