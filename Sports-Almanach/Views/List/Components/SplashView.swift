//
//  SpllashView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 21.09.24.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject private var viewModel = SplashViewModel()
    @State private var isMoving = false

    let sportImages = ["fussball", "football", "basketball"]

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("splashsporthintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 50) {
                    Text("Sports Almanach")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    Image("appimage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()

                    // Animierte Bilder
                    VStack(spacing: 40) {
                        ForEach(0..<sportImages.count, id: \.self) { index in
                            Image(sportImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .offset(y: isMoving ? CGFloat(index) * 30.0 : 0)
                        }
                    }
                    .onAppear {
                        // Startet die Animation, sobald die Ansicht erscheint
                        withAnimation(.easeInOut(duration: 1).delay(0.5).repeatForever(autoreverses: true)) {
                            isMoving.toggle()
                        }
                    }

                    Spacer()
                }
                 }
                 .navigationDestination(isPresented: $viewModel.showLoginView) {
                     LoginView()
                         .environmentObject(UserViewModel()) // Hier die richtige VM setzen
                 }
             }
         }
     }

#Preview {
    SplashView()
        .environmentObject(SplashViewModel())
    
        // Benötigt für Vorschau zur nächsten View
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
