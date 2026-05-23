//
//  InputField.swift
//  Sports-Almanach
//
//  Reusable text field component, polished for iOS-HIG. Replaces the legacy
//  field which mixed visibility-toggle into the same struct and used a
//  hard-coded 300×50 frame. New version uses Dynamic Type, semantic icons,
//  and `.ultraThinMaterial` so it blends with both photographic and gradient
//  backgrounds.
//

import SwiftUI

struct InputField: View {

    let title: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var isSecure: Bool = false
    var contentType: UITextContentType? = nil
    var keyboard: UIKeyboardType = .default

    @State private var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            HStack(spacing: AppTheme.Spacing.s) {
                Image(systemName: systemImage)
                    .foregroundStyle(AppTheme.Colors.accent)
                    .frame(width: 22)
                    .accessibilityHidden(true)

                input
                    .textInputAutocapitalization(autocapitalization)
                    .textContentType(contentType)
                    .keyboardType(keyboard)
                    .autocorrectionDisabled(isSecure || keyboard == .emailAddress)
                    .foregroundStyle(.white)
                    .tint(AppTheme.Colors.accent)

                if isSecure {
                    Button {
                        revealed.toggle()
                    } label: {
                        Image(systemName: revealed ? "eye.slash" : "eye")
                            .foregroundStyle(AppTheme.Colors.accent)
                    }
                    .accessibilityLabel(revealed ? "Passwort verbergen" : "Passwort anzeigen")
                }
            }
            .padding(AppTheme.Spacing.m)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(AppTheme.Colors.accent.opacity(0.55), lineWidth: 1)
            )
        }
    }

    private var autocapitalization: TextInputAutocapitalization {
        switch contentType {
        case .emailAddress, .username, .password, .newPassword:
            return .never
        case .nickname, .name, .givenName, .familyName:
            return .words
        default:
            return .sentences
        }
    }

    @ViewBuilder
    private var input: some View {
        if isSecure && !revealed {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text)
        }
    }
}
