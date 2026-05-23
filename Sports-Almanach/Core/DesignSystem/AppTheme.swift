//
//  AppTheme.swift
//  Sports-Almanach
//
//  Central design tokens (color, spacing, typography, radius, shadow).
//  All views should consume tokens — never hardcode colors or magic numbers.
//

import SwiftUI

/// Single source of truth for the visual language.
/// Driven by semantic intent (primary/secondary/destructive) rather than raw hue,
/// so theming and dark-mode adaptation happen in one place.
public enum AppTheme {

    // MARK: - Colors (semantic)
    public enum Colors {
        /// Brand accent — used sparingly for primary CTAs and highlights.
        public static let accent = Color("AccentColor")

        /// Surface levels — built atop materials so dark-mode adapts automatically.
        public static let surfacePrimary = Color(.systemBackground)
        public static let surfaceSecondary = Color(.secondarySystemBackground)
        public static let surfaceTertiary = Color(.tertiarySystemBackground)

        /// Foreground hierarchy — semantic, not white-on-image.
        public static let textPrimary = Color(.label)
        public static let textSecondary = Color(.secondaryLabel)
        public static let textTertiary = Color(.tertiaryLabel)

        /// Functional colors with iOS semantics.
        public static let success = Color.green
        public static let warning = Color.orange
        public static let destructive = Color.red
        public static let info = Color.blue

        /// Outcome colors — kept consistent across BetRow, BetSlipRow, StatisticSlipRow.
        public static let homeWin = Color.green
        public static let draw = Color.yellow
        public static let awayWin = Color.blue

        /// Win/loss state.
        public static let won = Color.green
        public static let lost = Color.red
        public static let pending = Color.orange
    }

    // MARK: - Spacing — 4pt grid
    public enum Spacing {
        public static let xxs: CGFloat = 2
        public static let xs: CGFloat = 4
        public static let s: CGFloat = 8
        public static let m: CGFloat = 12
        public static let l: CGFloat = 16
        public static let xl: CGFloat = 24
        public static let xxl: CGFloat = 32
        public static let xxxl: CGFloat = 48
    }

    // MARK: - Radius
    public enum Radius {
        public static let s: CGFloat = 8
        public static let m: CGFloat = 12
        public static let l: CGFloat = 16
        public static let xl: CGFloat = 24
        public static let pill: CGFloat = 999
    }

    // MARK: - Typography
    /// Uses Apple's Dynamic Type so the app respects user accessibility preferences.
    /// Avoid `.font(.system(size: 18, weight: .bold))` — it defeats Dynamic Type.
    public enum Typography {
        public static let largeTitle = Font.largeTitle.weight(.bold)
        public static let title = Font.title.weight(.semibold)
        public static let title2 = Font.title2.weight(.semibold)
        public static let title3 = Font.title3.weight(.medium)
        public static let headline = Font.headline
        public static let body = Font.body
        public static let callout = Font.callout
        public static let subheadline = Font.subheadline
        public static let footnote = Font.footnote
        public static let caption = Font.caption
        public static let caption2 = Font.caption2
    }

    // MARK: - Shadows
    public enum Shadow {
        public static let small = ShadowStyle(radius: 4, x: 0, y: 2, opacity: 0.08)
        public static let medium = ShadowStyle(radius: 12, x: 0, y: 6, opacity: 0.12)
        public static let large = ShadowStyle(radius: 24, x: 0, y: 12, opacity: 0.16)
    }

    public struct ShadowStyle {
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
        public let opacity: Double
    }

    // MARK: - Animation
    public enum Motion {
        public static let snappy = Animation.spring(response: 0.35, dampingFraction: 0.85)
        public static let smooth = Animation.easeInOut(duration: 0.25)
        public static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.65)
    }
}

// MARK: - View modifiers for ergonomic token use

public extension View {
    /// Applies a token-driven shadow.
    func appShadow(_ style: AppTheme.ShadowStyle = AppTheme.Shadow.small) -> some View {
        shadow(color: .black.opacity(style.opacity), radius: style.radius, x: style.x, y: style.y)
    }

    /// Standard card surface — used for rows, sheets, list items.
    func appCard(padding: CGFloat = AppTheme.Spacing.l,
                 radius: CGFloat = AppTheme.Radius.l) -> some View {
        self
            .padding(padding)
            .background(AppTheme.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .appShadow()
    }
}
