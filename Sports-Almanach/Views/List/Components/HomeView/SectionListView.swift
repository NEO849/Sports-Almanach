//
//  SectionListView.swift
//  Sports-Almanach
//
//  Home "what's inside" accordion. Re-skinned onto the design system: token
//  spacing, dark glass cards, a brand-orange chevron and a soft accent glow on
//  the expanded card so the focus reads instantly.
//

import SwiftUI

struct SectionListView: View {
    @Binding var expandedSection: String?

    private let sections: [(name: String, icon: String, blurb: String)] = [
        ("Events", "calendar", "Hier findest du eine riesige Auswahl an Events von verschiedenen Sportarten."),
        ("Event-Details", "play.rectangle.fill", "Infos jeglicher Art, das Spiel als Video verfolgen und deine Lieblingsszenen anschauen."),
        ("Wetten", "dollarsign.circle.fill", "Zeig dein Können als Sport-Analyst, teste dein Wissen und wette auf spannende Spiele."),
        ("Statistiken", "chart.line.uptrend.xyaxis", "Behalte den Überblick: Ranglisten und vieles mehr.")
    ]

    var body: some View {
        VStack(spacing: AppTheme.Spacing.m) {
            ForEach(sections, id: \.name) { section in
                SectionView(
                    sectionName: section.name,
                    icon: section.icon,
                    blurb: section.blurb,
                    expandedSection: $expandedSection
                )
            }
        }
    }
}

struct SectionView: View {
    let sectionName: String
    let icon: String
    let blurb: String
    @Binding var expandedSection: String?

    private var isExpanded: Bool { expandedSection == sectionName }

    private var sectionOpacity: Double {
        expandedSection == nil || expandedSection == sectionName ? 1.0 : 0.35
    }

    var body: some View {
        DisclosureGroup(isExpanded: Binding(
            get: { isExpanded },
            set: { expandedSection = $0 ? sectionName : nil }
        )) {
            Text(blurb)
                .font(AppTheme.Typography.callout)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, AppTheme.Spacing.s)
        } label: {
            HStack(spacing: AppTheme.Spacing.m) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(AppTheme.Gradients.brand)
                    .frame(width: 26)
                Text(sectionName)
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Spacer()
            }
        }
        .tint(AppTheme.Colors.accent)
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .strokeBorder(isExpanded ? AppTheme.Colors.accent.opacity(0.55) : AppTheme.Colors.strokeSubtle,
                              lineWidth: 1)
        )
        .shadow(color: AppTheme.Colors.accent.opacity(isExpanded ? 0.28 : 0), radius: 16, y: 8)
        .opacity(sectionOpacity)
        .animation(AppTheme.Motion.snappy, value: expandedSection)
    }
}

#if DEBUG
#Preview("SectionList") {
    ScrollView {
        SectionListView(expandedSection: .constant("Wetten"))
            .padding()
    }
    .frame(maxHeight: .infinity)
    .appBackground(.gradient)
}
#endif
