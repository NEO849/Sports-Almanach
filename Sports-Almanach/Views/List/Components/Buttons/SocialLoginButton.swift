//
//  SocialLoginButton.swift
//  Sports-Almanach
//
//  Secondary "glass" button for social providers — dark material pill with a
//  brand-tinted hairline and the same tactile press feedback as the primary CTA.
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
                    .font(.title3.weight(.semibold))
                Text(title)
                    .font(AppTheme.Typography.subheadline.weight(.semibold))
            }
            .foregroundStyle(AppTheme.Colors.textPrimary)
            .padding(.horizontal, AppTheme.Spacing.l)
            .frame(minHeight: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
            )
        }
        .buttonStyle(PressableButtonStyle())
        .accessibilityLabel("Mit \(title) anmelden")
    }
}

#if DEBUG
#Preview("SocialLoginButton") {
    VStack(spacing: AppTheme.Spacing.l) {
        SocialLoginButton(title: "Google", icon: "g.circle.fill", platform: .google) {}
        SocialLoginButton(title: "Apple", icon: "apple.logo", platform: .apple) {}
    }
    .padding()
    .frame(maxHeight: .infinity)
    .appBackground(.gradient)
}
#endif
