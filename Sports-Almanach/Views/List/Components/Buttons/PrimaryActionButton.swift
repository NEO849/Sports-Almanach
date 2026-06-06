//
//  PrimaryActionButton.swift
//  Sports-Almanach
//
//  Senior-elite primary CTA — single source of truth for "the big button".
//  Brand-orange gradient, an outer accent glow, a tactile press-in animation and
//  an integrated loading state so callers never juggle their own ProgressView.
//

import SwiftUI

struct PrimaryActionButton: View {

    let title: String
    let icon: String?
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void

    init(title: String,
         icon: String? = nil,
         isEnabled: Bool = true,
         isLoading: Bool = false,
         action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: trigger) {
            ZStack {
                HStack(spacing: AppTheme.Spacing.s) {
                    if let icon {
                        Image(systemName: icon)
                            .font(.headline.weight(.bold))
                    }
                    Text(title.uppercased())
                        .font(AppTheme.Typography.headline.weight(.bold))
                        .kerning(0.5)
                }
                .foregroundStyle(.white)
                .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(background)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1 : 0.45)
        .saturation(isEnabled ? 1 : 0.6)
        .animation(AppTheme.Motion.snappy, value: isEnabled)
        .animation(AppTheme.Motion.snappy, value: isLoading)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }

    private func trigger() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        action()
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
            .fill(AppTheme.Gradients.brand)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(AppTheme.Gradients.edgeHighlight)
                    .blendMode(.plusLighter)
                    .opacity(0.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: AppTheme.Colors.accent.opacity(isEnabled ? 0.45 : 0), radius: 16, y: 8)
    }
}

/// Tactile press-in feedback reused by the app's prominent buttons.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .brightness(configuration.isPressed ? -0.04 : 0)
            .animation(AppTheme.Motion.snappy, value: configuration.isPressed)
    }
}

#if DEBUG
#Preview("PrimaryActionButton") {
    VStack(spacing: AppTheme.Spacing.l) {
        PrimaryActionButton(title: "Login", icon: "arrow.right.circle.fill") {}
        PrimaryActionButton(title: "Lädt", isLoading: true) {}
        PrimaryActionButton(title: "Deaktiviert", isEnabled: false) {}
    }
    .padding()
    .frame(maxHeight: .infinity)
    .appBackground(.gradient)
}
#endif
