//
//  PrimaryActionButton.swift
//  Sports-Almanach
//
//  Senior-elite primary CTA — single source of truth for "the big button".
//  Accepts an explicit `isLoading` so callers don't need to juggle inner
//  ProgressViews, and falls back to a system-feedback haptic on tap.
//

import SwiftUI

struct PrimaryActionButton: View {

    let title: String
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void

    init(title: String,
         isEnabled: Bool = true,
         isLoading: Bool = false,
         action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: trigger) {
            ZStack {
                Text(title.uppercased())
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.white)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(background)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1 : 0.5)
        .animation(AppTheme.Motion.snappy, value: isEnabled)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }

    private func trigger() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        action()
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [AppTheme.Colors.accent, AppTheme.Colors.accent.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: AppTheme.Colors.accent.opacity(0.3), radius: 12, y: 6)
    }
}
