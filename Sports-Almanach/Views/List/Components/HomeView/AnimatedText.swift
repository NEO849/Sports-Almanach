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
                .fill(.gray)
                .cornerRadius(10)
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
