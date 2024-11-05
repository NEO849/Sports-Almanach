//
//  SpllashView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 21.09.24.
// .

import SwiftUI
import AVKit

struct SplashView: View {
    
    @State private var showLoginView = false
    @State private var player: AVPlayer? // Für AVPlayer
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                // Überprüft ob die Video-URL existiert
                if let videoURL = Bundle.main.url(forResource: "splashintro", withExtension: "mp4") {
                    // VP mit AVPlayer initial. und Starten
                    VideoPlayer(player: player ?? AVPlayer(url: videoURL))
                        .onAppear {
                            player = AVPlayer(url: videoURL)
                            player?.play()
                            
                            // Navigation auslösen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
                                showLoginView = true
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                } else {
                    ProgressView()
                        .scaleEffect(3.3, anchor: .center)
                        .foregroundColor(.orange)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .center) {
                            Text("@ 2024 Michael F. J. / AI-Data-F3 Team")
                                .font(.footnote)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            
                            Text("Version 1.0.1")
                                .font(.footnote)
                                .foregroundColor(.orange)
                                .padding(.bottom, 10)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                    }
                }
            }
            .navigationDestination(isPresented: $showLoginView) {
                // Wenn showLoginView true
               // LoginView()
            }
        }
    }
}

#Preview {
    SplashView()
}
