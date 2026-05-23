//
//  AnimatedText.swift
//  Sports-Almanach
//
//  Slide-in tagline. Uses Dynamic Type and a more subtle spring instead of
//  the legacy 4-second linear animation.
//

import SwiftUI

struct AnimatedText: View {
    @State private var visible = false

    var body: some View {
        Text("Infos, Wetten und mehr — viel Spaß!")
            .font(AppTheme.Typography.title3.weight(.medium))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.vertical, AppTheme.Spacing.s)
            .padding(.horizontal, AppTheme.Spacing.l)
            .background(
                Capsule().fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule().strokeBorder(AppTheme.Colors.accent.opacity(0.55), lineWidth: 1)
            )
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 18)
            .onAppear {
                withAnimation(AppTheme.Motion.bouncy.delay(0.1)) { visible = true }
            }
    }
}
