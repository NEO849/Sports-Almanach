//
//  SplashView.swift
//  Sports-Almanach
//
//  Splash with the intro video. Uses `Task.sleep` (cancellable) instead of
//  the legacy `DispatchQueue.main.asyncAfter`, and signals completion via
//  callback so RootView can swap to the next phase.
//

import SwiftUI
import AVKit

struct SplashView: View {

    let onFinished: () -> Void

    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            videoLayer
                .ignoresSafeArea()

            VStack {
                Spacer()
                signature
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.bottom, AppTheme.Spacing.l)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: UInt64(AppConstants.Splash.totalSeconds * 1_000_000_000))
            onFinished()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }

    @ViewBuilder
    private var videoLayer: some View {
        if let url = Bundle.main.url(forResource: AppConstants.Splash.videoFileName, withExtension: "mp4") {
            VideoPlayer(player: player ?? AVPlayer(url: url))
                .onAppear {
                    let p = AVPlayer(url: url)
                    p.isMuted = true
                    p.play()
                    player = p
                }
        } else {
            AppTheme.Colors.surfacePrimary
                .overlay {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(AppTheme.Colors.accent)
                }
        }
    }

    // Ruhiger, hochwertiger Footer: kein Orange-Rahmen mehr, gedämpfte Typo
    // mit feinem Tracking und einem dünnen Akzent-Strich als einziger Farbe.
    private var signature: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Capsule()
                .fill(AppTheme.Colors.accent)
                .frame(width: 28, height: 2)
                .opacity(0.8)
            Text("© 2024 MICHAEL F. J. · AI-DATA-F3")
                .font(AppTheme.Typography.caption2.weight(.medium))
                .kerning(1.5)
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("Version 2.0")
                .font(AppTheme.Typography.caption2)
                .foregroundStyle(AppTheme.Colors.textTertiary.opacity(0.7))
        }
        .multilineTextAlignment(.center)
    }
}

#if DEBUG
#Preview("Splash") {
    SplashView(onFinished: {})
        .preferredColorScheme(.dark)
}
#endif
