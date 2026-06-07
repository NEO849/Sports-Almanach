//
//  AppBackground.swift
//  Sports-Almanach
//
//  Gemeinsame Hintergrund-Fläche (rein visuell). Designziel: sehr dunkel und
//  ruhig — tiefes Schwarz mit warmem Unterton, dezente Vignette für Tiefe und
//  nur ein sehr leiser, weit oben sitzender Glow als Energie-Akzent. Kein
//  dominanter Orange-Verlauf mehr.
//

import SwiftUI

/// Wendet den Marken-Hintergrund an.
public struct AppBackground: ViewModifier {

    public enum Style {
        /// Fotografischer Hintergrund mit dunklem Scrim (Legacy-kompatibel).
        case photographic
        /// Solide, fast schwarze Fläche.
        case solid
        /// Marken-Backdrop: tiefes Schwarz + Vignette + sehr dezenter Glow. Default.
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
                // Kräftiger, neutraler Scrim — Foto deutlich abdunkeln.
                LinearGradient(
                    colors: [.black.opacity(0.86), .black.opacity(0.62), .black.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                AppTheme.Gradients.vignette
            }

        case .solid:
            AppTheme.Brand.black

        case .gradient:
            ZStack {
                // 1) Sehr dunkler Basis-Verlauf (Schwarz → warmes Schwarz → Schwarz)
                AppTheme.Gradients.backdrop

                // 2) Leiser warmer Glow, weit oben — Energie ohne Lautstärke
                AppTheme.Gradients.glow
                    .scaleEffect(1.2)
                    .offset(y: -300)
                    .blendMode(.plusLighter)
                    .opacity(0.55)

                // 3) Vignette — verdunkelt die Ränder, lenkt den Blick zur Mitte
                AppTheme.Gradients.vignette
                    .blendMode(.multiply)
            }
        }
    }
}

public extension View {
    func appBackground(_ style: AppBackground.Style = .gradient) -> some View {
        modifier(AppBackground(style: style))
    }
}
