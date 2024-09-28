//
//  SpllashView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 21.09.24.
//

import SwiftUI
import AVKit

struct SplashView: View {
    
    @StateObject private var viewModel = SplashViewModel()
    @State private var showLoginView = false
    @State private var player: AVPlayer? // Für AVPlayer
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                // Überprüft ob die Video-URL existiert
                if let videoURL = Bundle.main.url(forResource: "splashintro", withExtension: "mp4") {
                    // VideoPlayer mit AVPlayer initialisieren und Starten
                    VideoPlayer(player: player ?? AVPlayer(url: videoURL))
                        .onAppear {
                            player = AVPlayer(url: videoURL)
                            player?.play()
                            
                            // Navigation auslösen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                showLoginView = true
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                } else {
                    ProgressView()
                        .scaleEffect(5.0, anchor: .center)
                        .foregroundColor(.orange)
                }
                
                VStack {
                    Spacer()
                    
                    // Text am unteren Rand
                    Text("@ 2024 Michael F. J. AI-Data-F3 Team\nVersion 1.0.1")
                        .font(.footnote)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                        .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $showLoginView) {
                LoginView()
                    .environmentObject(UserViewModel())
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(SplashViewModel())
    // Für Vorschau zur nächsten View
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
