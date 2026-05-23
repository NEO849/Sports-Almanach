//
//  AppBackground.swift
//  Sports-Almanach
//
//  Single shared background surface — replaces the 6+ duplicated
//  `Image("hintergrund").resizable().scaledToFill().edgesIgnoringSafeArea(.all)`
//  blocks across the legacy Views.
//

import SwiftUI

/// Applies the app's brand background. Compositing layer with a subtle scrim
/// preserves contrast against any foreground content (iOS-HIG: readable text
/// over imagery requires explicit overlay treatment).
public struct AppBackground: ViewModifier {

    public enum Style {
        /// Original photographic background with a darken-scrim for legibility.
        case photographic
        /// Solid surface using semantic system background — dark/light mode aware.
        case solid
        /// Branded gradient — preferred for hero sections.
        case gradient
    }

    public let style: Style

    public func body(content: Content) -> some View {
        ZStack {
            backdrop
                .ignoresSafeArea()
            content
        }
    }

    @ViewBuilder
    private var backdrop: some View {
        switch style {
        case .photographic:
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                // Scrim — keeps text readable regardless of image content.
                LinearGradient(
                    colors: [.black.opacity(0.55), .black.opacity(0.30), .black.opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        case .solid:
            AppTheme.Colors.surfacePrimary
        case .gradient:
            LinearGradient(
                colors: [
                    AppTheme.Colors.surfacePrimary,
                    AppTheme.Colors.accent.opacity(0.18),
                    AppTheme.Colors.surfacePrimary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

public extension View {
    func appBackground(_ style: AppBackground.Style = .photographic) -> some View {
        modifier(AppBackground(style: style))
    }
}
