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
            .font(AppTheme.Typography.largeTitle.italic())
            .foregroundStyle(.white)
            .shadow(color: AppTheme.Colors.accent.opacity(0.55), radius: 8, y: 3)
            .multilineTextAlignment(.center)
            .accessibilityAddTraits(.isHeader)
    }
}
