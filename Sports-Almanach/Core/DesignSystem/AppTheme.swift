//
//  AppTheme.swift
//  Sports-Almanach
//
//  Central design tokens (color, gradient, spacing, typography, radius, shadow).
//  All views should consume tokens — never hardcode colors or magic numbers.
//
//  Visual language: a dark "stadium at night" theme — deep blacks and warm
//  charcoals lit by a single confident orange brand accent. Every surface is
//  built from these tokens so the look stays consistent across every screen.
//

import SwiftUI
import UIKit

/// Single source of truth for the visual language.
/// Driven by semantic intent (primary/secondary/destructive) rather than raw hue,
/// so theming happens in exactly one place.
public enum AppTheme {

    // MARK: - Brand palette (raw hues — prefer the semantic tokens below)
    public enum Brand {
        /// The signature orange. Used for the primary accent everywhere.
        public static let orange       = Color(hex: 0xFF7A00)
        public static let orangeBright = Color(hex: 0xFF9D2E)
        public static let orangeDeep   = Color(hex: 0xE2560A)
        public static let amber        = Color(hex: 0xFFB347)

        /// Neutral spine — near-black to warm charcoal to graphite.
        public static let black     = Color(hex: 0x0A0A0B)
        public static let ink       = Color(hex: 0x121214)
        public static let charcoal  = Color(hex: 0x1B1B1F)
        public static let graphite  = Color(hex: 0x26262B)
        public static let slate     = Color(hex: 0x34343B)
    }

    // MARK: - Colors (semantic)
    public enum Colors {
        /// Brand accent — primary CTAs, focus rings, highlights.
        public static let accent       = Brand.orange
        public static let accentBright = Brand.orangeBright
        public static let accentDeep   = Brand.orangeDeep

        /// Surface levels — dark, elevation increases with the index.
        public static let surfacePrimary   = Brand.ink
        public static let surfaceSecondary = Brand.charcoal
        public static let surfaceTertiary  = Brand.graphite
        public static let surfaceElevated  = Brand.slate

        /// Foreground hierarchy.
        public static let textPrimary   = Color.white
        public static let textSecondary = Color(hex: 0xB4B4BD)
        public static let textTertiary  = Color(hex: 0x7C7C85)

        /// Hairlines & strokes.
        public static let hairline      = Color.white.opacity(0.08)
        public static let strokeSubtle  = Color.white.opacity(0.12)

        /// Functional colors.
        public static let success     = Color(hex: 0x32D74B)
        public static let warning     = Brand.amber
        public static let destructive = Color(hex: 0xFF453A)
        public static let info        = Color(hex: 0x0A84FF)

        /// Outcome colors — consistent across BetRow, BetSlipRow, StatisticSlipRow.
        public static let homeWin = Color(hex: 0x32D74B)
        public static let draw    = Brand.amber
        public static let awayWin = Color(hex: 0x0A84FF)

        /// Win/loss state.
        public static let won     = Color(hex: 0x32D74B)
        public static let lost    = Color(hex: 0xFF453A)
        public static let pending = Brand.orange
    }

    // MARK: - Gradients
    public enum Gradients {
        /// The hero brand gradient — diagonal orange used on the primary CTA & accents.
        public static let brand = LinearGradient(
            colors: [Brand.orangeBright, Brand.orange, Brand.orangeDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// Full-screen app backdrop — black with a warm spotlight from the top.
        public static let backdrop = LinearGradient(
            colors: [Brand.black, Brand.ink, Color(hex: 0x171311), Brand.black],
            startPoint: .top,
            endPoint: .bottom
        )

        /// Subtle elevated-surface fill for cards/rows.
        public static let surface = LinearGradient(
            colors: [Color.white.opacity(0.07), Color.white.opacity(0.02)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// Glass stroke that catches the light along the top edge of a card.
        public static let edgeHighlight = LinearGradient(
            colors: [Color.white.opacity(0.22), Color.white.opacity(0.04), Color.clear],
            startPoint: .top,
            endPoint: .bottom
        )

        /// Warm radial glow placed behind hero content.
        public static let glow = RadialGradient(
            colors: [Brand.orange.opacity(0.45), Brand.orange.opacity(0.0)],
            center: .center,
            startRadius: 2,
            endRadius: 320
        )
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
    public enum Typography {
        public static let largeTitle = Font.largeTitle.weight(.bold)
        public static let title = Font.title.weight(.bold)
        public static let title2 = Font.title2.weight(.semibold)
        public static let title3 = Font.title3.weight(.semibold)
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
        public static let small  = ShadowStyle(radius: 6,  x: 0, y: 3,  opacity: 0.35)
        public static let medium = ShadowStyle(radius: 16, x: 0, y: 8,  opacity: 0.45)
        public static let large  = ShadowStyle(radius: 30, x: 0, y: 16, opacity: 0.55)
        /// Coloured glow used under accent elements.
        public static let glow   = ShadowStyle(radius: 18, x: 0, y: 8,  opacity: 0.55)
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

    // MARK: - UIKit appearance
    /// Themes the UIKit-backed chrome (tab bar, nav bar) once at launch so the
    /// SwiftUI surfaces and the system bars share one dark/orange identity.
    public static func configureUIKitAppearance() {
        let orange = UIColor(red: 1.0, green: 0x7A/255, blue: 0.0, alpha: 1)
        let ink    = UIColor(red: 0x12/255, green: 0x12/255, blue: 0x14/255, alpha: 1)
        let gray   = UIColor(red: 0x7C/255, green: 0x7C/255, blue: 0x85/255, alpha: 1)

        // Tab bar — opaque dark with an orange selected state.
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = ink
        tab.shadowColor = UIColor.white.withAlphaComponent(0.08)
        let item = tab.stackedLayoutAppearance
        item.selected.iconColor = orange
        item.selected.titleTextAttributes = [.foregroundColor: orange]
        item.normal.iconColor = gray
        item.normal.titleTextAttributes = [.foregroundColor: gray]
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab

        // Nav bar — transparent over the gradient, white titles, orange buttons.
        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.titleTextAttributes = [.foregroundColor: UIColor.white]
        nav.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav
        UINavigationBar.appearance().tintColor = orange
    }
}

// MARK: - Color hex convenience

public extension Color {
    /// Build an opaque color from a 0xRRGGBB literal — keeps the palette readable.
    init(hex: UInt32, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

// MARK: - View modifiers for ergonomic token use

public extension View {
    /// Applies a token-driven shadow.
    func appShadow(_ style: AppTheme.ShadowStyle = AppTheme.Shadow.small) -> some View {
        shadow(color: .black.opacity(style.opacity), radius: style.radius, x: style.x, y: style.y)
    }

    /// Coloured accent glow — for hero elements and active controls.
    func accentGlow(_ color: Color = AppTheme.Colors.accent, radius: CGFloat = 18, opacity: Double = 0.5) -> some View {
        shadow(color: color.opacity(opacity), radius: radius, x: 0, y: 8)
    }

    /// Standard elevated card surface — dark glass with a top edge-highlight.
    func appCard(padding: CGFloat = AppTheme.Spacing.l,
                 radius: CGFloat = AppTheme.Radius.l) -> some View {
        self
            .padding(padding)
            .background(AppTheme.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .background(AppTheme.Gradients.surface, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(AppTheme.Colors.hairline, lineWidth: 1)
            )
            .appShadow(AppTheme.Shadow.medium)
    }
}
