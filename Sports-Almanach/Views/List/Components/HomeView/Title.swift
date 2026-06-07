//
//  Title.swift
//  Sports-Almanach
//
//  Brand display-text. Replaces the hard-coded `.custom("Helvetica Neue Bold
//  Italic", size: 32)` — that disabled Dynamic Type — with a Dynamic-Type-
//  aware large title plus a single subtle shadow.
//

import SwiftUI

struct Title: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.largeTitle)
            .foregroundStyle(AppTheme.Colors.textPrimary)
            // Sehr dezenter, warmer Glow als Akzent — kein lautes Leuchten.
            .shadow(color: AppTheme.Colors.accent.opacity(0.25), radius: 6, y: 2)
            .multilineTextAlignment(.center)
            .accessibilityAddTraits(.isHeader)
    }
}

#if DEBUG
#Preview("Title") {
    Title(title: "Sports Almanach")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground(.gradient)
}
#endif
