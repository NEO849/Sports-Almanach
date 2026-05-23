//
//  SocialLoginButton.swift
//  Sports-Almanach
//

import SwiftUI

enum SocialPlatform: String {
    case google, facebook, apple
}

struct SocialLoginButton: View {

    let title: String
    let icon: String
    let platform: SocialPlatform
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.s) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(AppTheme.Typography.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, AppTheme.Spacing.l)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(AppTheme.Colors.accent.opacity(0.6), lineWidth: 1)
            )
        }
        .accessibilityLabel("Mit \(title) anmelden")
    }
}
