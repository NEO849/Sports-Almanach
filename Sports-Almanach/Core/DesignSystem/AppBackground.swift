//
//  AppBackground.swift
//  Sports-Almanach
//
//  Single shared background surface — replaces the 6+ duplicated
//  `Image("hintergrund")...` blocks across the legacy Views.
//
//  The brand backdrop is a near-black gradient lit by a soft orange glow in the
//  upper third — the "floodlit stadium" feel — so foreground content always sits
//  on a calm, high-contrast surface.
//

import SwiftUI

/// Applies the app's brand background.
public struct AppBackground: ViewModifier {

    public enum Style {
        /// Original photographic background with a darken-scrim for legibility.
        case photographic
        /// Solid near-black surface.
        case solid
        /// Branded black→charcoal gradient with a warm orange glow. The default hero.
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
                // Warm scrim — darkens the photo and ties it to the brand palette.
                LinearGradient(
                    colors: [.black.opacity(0.78), .black.opacity(0.45), .black.opacity(0.82)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                AppTheme.Brand.orange.opacity(0.10).blendMode(.plusLighter)
            }

        case .solid:
            AppTheme.Brand.black

        case .gradient:
            ZStack {
                AppTheme.Gradients.backdrop
                // Floodlight glow, anchored to the top so hero content is lit.
                AppTheme.Gradients.glow
                    .scaleEffect(1.4)
                    .offset(y: -260)
                    .blendMode(.plusLighter)
                    .opacity(0.9)
            }
        }
    }
}

public extension View {
    func appBackground(_ style: AppBackground.Style = .gradient) -> some View {
        modifier(AppBackground(style: style))
    }
}
