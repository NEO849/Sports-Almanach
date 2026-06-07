//
//  AppTheme.swift
//  Sports-Almanach
//
//  Zentrale, rein visuelle Design-Tokens (Farbe, Verlauf, Abstand, Radius,
//  Schatten, Typografie, Animation). KEINE Geschäfts-/Daten-/API-Logik.
//
//  Designrichtung: dunkle, edle, technische Premium-Sport-App. Tiefes Schwarz /
//  Anthrazit / Graphit mit warmem Schwarz-Braun-Unterton; Orange/Amber NUR als
//  kontrollierter Akzent. Kantig statt rund, Tiefe durch Layer + Vignette +
//  dezente Glows.
//

import SwiftUI
import UIKit

/// Single source of truth für die visuelle Sprache.
public enum AppTheme {

    // MARK: - Brand-Palette (Rohtöne — bevorzugt die semantischen Tokens unten)
    public enum Brand {
        /// Gedämpftes Orange — der einzige laute Ton, sparsam eingesetzt.
        public static let orange       = Color(hex: 0xD96523)
        /// Warmes Amber — für Highlights/aktive Zustände.
        public static let amber        = Color(hex: 0xE49A4C)
        public static let orangeDeep   = Color(hex: 0xA8481A)

        /// Neutrale Achse — von tiefem Schwarz über warmes Schwarz zu Graphit.
        public static let black        = Color(hex: 0x050506)
        public static let warmBlack    = Color(hex: 0x0C0A08)   // Schwarz mit Braun-Unterton
        public static let ink          = Color(hex: 0x0E0E11)
        public static let charcoal     = Color(hex: 0x16161A)
        public static let graphite     = Color(hex: 0x1E1E23)
        public static let slate        = Color(hex: 0x2A2A30)
    }

    // MARK: - Colors (semantisch)
    public enum Colors {
        /// Akzent — CTAs, Fokus, wichtige Werte. Gedämpft gehalten.
        public static let accent       = Brand.orange
        public static let accentBright = Brand.amber
        public static let accentDeep   = Brand.orangeDeep

        /// Oberflächen-Ebenen (Elevation steigt mit dem Index).
        public static let surfacePrimary   = Brand.ink
        public static let surfaceSecondary = Brand.charcoal
        public static let surfaceTertiary  = Brand.graphite
        public static let surfaceElevated  = Brand.slate

        /// Vordergrund-Hierarchie — Weiß bewusst leicht gedämpft (kein 100%-Weiß).
        public static let textPrimary   = Color(hex: 0xF1F1F3)
        public static let textSecondary = Color(hex: 0x9B9BA3)
        public static let textTertiary  = Color(hex: 0x646469)

        /// Outlines / Hairlines — sehr dezent.
        public static let hairline      = Color.white.opacity(0.06)
        public static let strokeSubtle  = Color.white.opacity(0.10)

        /// Funktionsfarben (gedämpft, nicht grell).
        public static let success     = Color(hex: 0x3BBF6B)
        public static let warning     = Brand.amber
        public static let destructive = Color(hex: 0xD2483F)
        public static let info        = Color(hex: 0x3D7FB8)

        /// Outcome-Farben — konsistent über BetRow/BetSlipRow/StatisticSlipRow.
        public static let homeWin = Color(hex: 0x3BBF6B)
        public static let draw    = Brand.amber
        public static let awayWin = Color(hex: 0x3D7FB8)

        /// Win/Loss-Zustand.
        public static let won     = Color(hex: 0x3BBF6B)
        public static let lost    = Color(hex: 0xD2483F)
        public static let pending = Brand.amber
    }

    // MARK: - Gradients (subtil halten)
    public enum Gradients {
        /// CTA-Verlauf — gedämpftes Orange, diagonal, nicht zu gesättigt.
        public static let brand = LinearGradient(
            colors: [Brand.amber, Brand.orange, Brand.orangeDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// Vollflächiger App-Hintergrund — sehr dunkel, nur ein Hauch warmer Ton.
        public static let backdrop = LinearGradient(
            colors: [Brand.black, Brand.warmBlack, Brand.ink, Brand.black],
            startPoint: .top,
            endPoint: .bottom
        )

        /// Dezente Füllung für Cards/Rows (Glas-Anmutung).
        public static let surface = LinearGradient(
            colors: [Color.white.opacity(0.05), Color.white.opacity(0.015)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// Lichtkante an der Oberkante einer Card.
        public static let edgeHighlight = LinearGradient(
            colors: [Color.white.opacity(0.14), Color.white.opacity(0.02), Color.clear],
            startPoint: .top,
            endPoint: .bottom
        )

        /// Sehr dezenter warmer Glow hinter Hero-Inhalten (klein + leise).
        public static let glow = RadialGradient(
            colors: [Brand.orange.opacity(0.22), Brand.orange.opacity(0.0)],
            center: .center,
            startRadius: 2,
            endRadius: 260
        )

        /// Vignette — verdunkelt die Ränder, schafft Tiefe & Fokus zur Mitte.
        public static let vignette = RadialGradient(
            colors: [Color.clear, Color.black.opacity(0.55)],
            center: .center,
            startRadius: 140,
            endRadius: 540
        )
    }

    // MARK: - Spacing — 4pt-Raster
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

    // MARK: - Radius — bewusst kantig
    public enum Radius {
        public static let s: CGFloat = 6      // kleine Elemente, Chips
        public static let m: CGFloat = 10     // Buttons, Inputs
        public static let l: CGFloat = 12     // Cards, Rows
        public static let xl: CGFloat = 16    // große Container (Maximum)
        public static let pill: CGFloat = 999 // nur für winzige Status-Badges
    }

    // MARK: - Typography
    /// Dynamic Type bleibt erhalten; Gewichte präziser für eine technische Anmutung.
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

    // MARK: - Shadows (auf Schwarz dezent halten)
    public enum Shadow {
        public static let small  = ShadowStyle(radius: 5,  x: 0, y: 2,  opacity: 0.40)
        public static let medium = ShadowStyle(radius: 14, x: 0, y: 7,  opacity: 0.50)
        public static let large  = ShadowStyle(radius: 26, x: 0, y: 14, opacity: 0.55)
        /// Akzent-Glow — bewusst leise.
        public static let glow   = ShadowStyle(radius: 14, x: 0, y: 6,  opacity: 0.40)
    }

    public struct ShadowStyle {
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
        public let opacity: Double
    }

    // MARK: - Animation
    public enum Motion {
        /// Ruhiger, technischer Default — kein Überschwingen.
        public static let snappy = Animation.spring(response: 0.34, dampingFraction: 0.92)
        public static let smooth = Animation.easeInOut(duration: 0.25)
        /// Dezent federnd (nur sparsam einsetzen).
        public static let bouncy = Animation.spring(response: 0.45, dampingFraction: 0.78)
    }

    // MARK: - UIKit-Appearance
    /// Themt die UIKit-Chrome (Tab-/Navigationsleiste) einmalig beim Start, damit
    /// SwiftUI-Flächen und Systemleisten dieselbe dunkle Identität teilen.
    public static func configureUIKitAppearance() {
        let orange = UIColor(red: 0xD9/255, green: 0x65/255, blue: 0x23/255, alpha: 1)
        let amber  = UIColor(red: 0xE4/255, green: 0x9A/255, blue: 0x4C/255, alpha: 1)
        let ink    = UIColor(red: 0x0E/255, green: 0x0E/255, blue: 0x11/255, alpha: 1)
        let gray   = UIColor(red: 0x64/255, green: 0x64/255, blue: 0x69/255, alpha: 1)

        // Tab-Bar — opak dunkel, Amber als aktiver Zustand.
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = ink
        tab.shadowColor = UIColor.white.withAlphaComponent(0.06)
        let item = tab.stackedLayoutAppearance
        item.selected.iconColor = amber
        item.selected.titleTextAttributes = [.foregroundColor: amber]
        item.normal.iconColor = gray
        item.normal.titleTextAttributes = [.foregroundColor: gray]
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab

        // Nav-Bar — transparent über dem Verlauf, weiße Titel, Orange-Buttons.
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

// MARK: - Color hex-Komfort

public extension Color {
    /// Opake Farbe aus 0xRRGGBB — hält die Palette lesbar.
    init(hex: UInt32, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

// MARK: - View-Modifier für ergonomische Token-Nutzung

public extension View {
    /// Token-gesteuerter Schatten.
    func appShadow(_ style: AppTheme.ShadowStyle = AppTheme.Shadow.small) -> some View {
        shadow(color: .black.opacity(style.opacity), radius: style.radius, x: style.x, y: style.y)
    }

    /// Dezenter Akzent-Glow — nur für Hero-Elemente / aktive Controls.
    func accentGlow(_ color: Color = AppTheme.Colors.accent, radius: CGFloat = 14, opacity: Double = 0.35) -> some View {
        shadow(color: color.opacity(opacity), radius: radius, x: 0, y: 6)
    }

    /// Standard-Card — dunkles Glas mit dezenter Oberkante + Hairline.
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
