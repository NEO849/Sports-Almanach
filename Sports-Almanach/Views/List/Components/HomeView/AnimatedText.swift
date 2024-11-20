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
            Text("Infos, Wetten, und vieles mehr... Viel Spaß!")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: 340)
                .background(
                    Color.black)
                .cornerRadius(10)
                .shadow(color: .white, radius: 10, x: 3, y: -3)
                .offset(x: textOffset)
                .onAppear {
                    withAnimation(.linear(duration: 4)) {
                        textOffset = 0
                    }
                }
        }
    }
}

#Preview {
    ZStack {
        Image("hintergrund")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
        AnimatedText()
    }
}
