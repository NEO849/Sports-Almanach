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
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous).fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous).strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
            )
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 18)
            .onAppear {
                withAnimation(AppTheme.Motion.bouncy.delay(0.1)) { visible = true }
            }
    }
}

#if DEBUG
#Preview("AnimatedText") {
    AnimatedText()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground(.gradient)
}
#endif
