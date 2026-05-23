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

    private var signature: some View {
        VStack(spacing: AppTheme.Spacing.xxs) {
            Text("© 2024 Michael F. J. / AI-Data-F3 Team")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.accent)
            Text("Version 2.0")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.accent.opacity(0.8))
        }
        .padding(.horizontal, AppTheme.Spacing.m)
        .padding(.vertical, AppTheme.Spacing.s)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.s, style: .continuous)
                .strokeBorder(AppTheme.Colors.accent.opacity(0.7), lineWidth: 1)
        )
    }
}
