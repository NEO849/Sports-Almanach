//
//  SocialLoginButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 18.11.24.
//

import SwiftUI

enum CustomButtons {
    case google
    case facebook
    case github
}

struct SocialLoginButton: View {
    let title: String
    let icon: String
    let platform: CustomButtons
    let action: () -> Void

    private static let gradientColors: [CustomButtons: Gradient] = [
        .google: Gradient(colors: [.black.opacity(0.9), .red]),
        .facebook: Gradient(colors: [.black.opacity(0.9), .blue])]

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.title2) 
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .frame(width: 94, height: 56)
            .padding(.horizontal, 22)
            .background(
                LinearGradient(gradient: Self.gradientColors[platform]!, startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.orange, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        Image("hintergrund")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
        
        SocialLoginButton(title: "Google",
                          icon: "g.circle.fill",
                          platform: .google,
                          action: {
            print("Google Login Button tapped")
        }
        )
    }
}
