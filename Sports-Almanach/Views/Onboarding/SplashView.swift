//
//  SpllashView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 21.09.24.
//

import SwiftUI
import AVKit

/// Splash screen displaying an intro video before navigating to the login screen
/// - Uses AVPlayer to play a video during app startup
/// - Automatically navigates to login after video playback
struct SplashView: View {
    
    // MARK: - Properties
    @State private var showLoginView = false
    @State private var player: AVPlayer?
    
    /// Duration after which to navigate to login screen (matches video length)
    private let navigationDelay: Double = 3.3
    private let videoFileName = "splashintro"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Check if the video URL exists in the bundle
                if let videoURL = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") {
                    // Initialize and start AVPlayer
                    VideoPlayer(player: player ?? AVPlayer(url: videoURL))
                        .onAppear {
                            // Create player instance and start playback
                            player = AVPlayer(url: videoURL)
                            player?.play()
                            
                            // Trigger navigation after video ends
                            DispatchQueue.main.asyncAfter(deadline: .now() + navigationDelay) {
                                showLoginView = true
                            }
                        }
                        .onDisappear {
                            // Clean up player resources when view disappears
                            player?.pause()
                            player = nil
                        }
                        .edgesIgnoringSafeArea(.all)
                } else {
                    // Fallback if video not found
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
                // Navigate to login when showLoginView becomes true
                LoginView()
            }
        }
    }
}

#Preview {
    SplashView()
}
