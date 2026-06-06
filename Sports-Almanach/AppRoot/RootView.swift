//
//  RootView.swift
//  Sports-Almanach
//
//  Top-level router. Renders Splash → Onboarding → MainTabView based on
//  the AppSession's phase. Single place that owns this branching, so
//  individual views no longer push/pop their way to the right screen.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var session: AppSession
    @State private var splashFinished = false

    var body: some View {
        ZStack {
            switch session.phase {
            case .bootstrapping:
                SplashView(onFinished: { splashFinished = true })
            case .unauthenticated:
                if splashFinished {
                    OnboardingFlowView()
                } else {
                    SplashView(onFinished: { splashFinished = true })
                }
            case .authenticated:
                MainTabView()
            }
        }
        .animation(AppTheme.Motion.smooth, value: session.phase)
        .preferredColorScheme(.dark)
        .tint(AppTheme.Colors.accent)
    }
}
