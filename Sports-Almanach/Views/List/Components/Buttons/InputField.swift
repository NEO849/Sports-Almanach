//
//  InputField.swift
//  Sports-Almanach
//
//  Reusable text field, polished to Apple-HIG. The field is *focus-aware*: when
//  the user taps in, the leading icon, label, border and an outer glow all
//  animate to the brand orange — clear, calm visual feedback about where the
//  keyboard is going. Uses Dynamic Type and `.ultraThinMaterial` so it reads on
//  both the photographic and gradient backdrops.
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
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.subheadline.weight(.semibold))
                .foregroundStyle(isFocused ? AppTheme.Colors.accentBright : AppTheme.Colors.textSecondary)
                .animation(AppTheme.Motion.smooth, value: isFocused)

            HStack(spacing: AppTheme.Spacing.s) {
                Image(systemName: systemImage)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isFocused ? AppTheme.Colors.accent : AppTheme.Colors.textTertiary)
                    .frame(width: 22)
                    .scaleEffect(isFocused ? 1.08 : 1.0)
                    .accessibilityHidden(true)

                input
                    .textInputAutocapitalization(autocapitalization)
                    .textContentType(contentType)
                    .keyboardType(keyboard)
                    .autocorrectionDisabled(isSecure || keyboard == .emailAddress)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .tint(AppTheme.Colors.accent)
                    .focused($isFocused)

                if isSecure {
                    Button {
                        revealed.toggle()
                    } label: {
                        Image(systemName: revealed ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(isFocused ? AppTheme.Colors.accent : AppTheme.Colors.textTertiary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(revealed ? "Passwort verbergen" : "Passwort anzeigen")
                }
            }
            .padding(AppTheme.Spacing.m)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(AppTheme.Colors.accent.opacity(isFocused ? 0.08 : 0))
            )
            .overlay(border)
            .shadow(color: AppTheme.Colors.accent.opacity(isFocused ? 0.35 : 0),
                    radius: isFocused ? 12 : 0, x: 0, y: 0)
            .animation(AppTheme.Motion.snappy, value: isFocused)
        }
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
    }

    // Border morphs from a faint hairline to a bright brand stroke on focus.
    private var border: some View {
        RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
            .strokeBorder(
                isFocused
                    ? AnyShapeStyle(AppTheme.Gradients.brand)
                    : AnyShapeStyle(AppTheme.Colors.strokeSubtle),
                lineWidth: isFocused ? 1.6 : 1
            )
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

#if DEBUG
#Preview("InputField") {
    VStack(spacing: AppTheme.Spacing.l) {
        InputField(title: "Email", placeholder: "name@beispiel.de",
                   systemImage: "envelope", text: .constant("max@beispiel.de"),
                   contentType: .emailAddress, keyboard: .emailAddress)
        InputField(title: "Passwort", placeholder: "Mindestens 8 Zeichen",
                   systemImage: "lock", text: .constant("geheim123"), isSecure: true)
    }
    .padding()
    .frame(maxHeight: .infinity)
    .appBackground(.gradient)
}
#endif
