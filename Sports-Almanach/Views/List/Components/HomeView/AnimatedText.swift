//
//  AnimatedText.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct AnimatedText: View {
    @State private var textOffset: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .cornerRadius(10)
                .background(
                    Color.white
                        .cornerRadius(10)
                        .opacity(0.3)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 3, y: 10)
                )
                .padding(.horizontal, 10)
                .frame(maxWidth: 340)
                .overlay(
                    Text("Infos, Wetten, und vieles mehr... Viel Spaß!")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            Color.black)
                        .cornerRadius(10)
                        .shadow(color: .white, radius: 10, x: 3, y: 10)
                )
                // Von Rechts nach Links
                .offset(x: textOffset)
                .onAppear {
                    withAnimation(.linear(duration: 5)) {
                        textOffset = 0
                    }
                }
        }
    }
}
