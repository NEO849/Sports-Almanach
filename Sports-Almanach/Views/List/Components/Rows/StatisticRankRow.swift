//
//  StatisticRankRow.swift
//  Sports-Almanach
//

import SwiftUI

struct StatisticRankRow: View {

    let rank: Int
    let profile: Profile

    var body: some View {
        HStack {
            badge
            Text(profile.username)
                .font(AppTheme.Typography.body)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            Text(profile.balance.formatted())
                .font(AppTheme.Typography.body.monospacedDigit())
                .foregroundStyle(profile.balance >= profile.startingBalance
                                 ? AppTheme.Colors.success
                                 : AppTheme.Colors.destructive)
        }
        .padding(AppTheme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }

    private var badge: some View {
        ZStack {
            Circle()
                .fill(badgeColor)
                .frame(width: 32, height: 32)
            Text("\(rank)")
                .font(AppTheme.Typography.subheadline.weight(.bold).monospacedDigit())
                .foregroundStyle(.white)
        }
    }

    private var badgeColor: Color {
        switch rank {
        case 1: return Color(red: 0.85, green: 0.65, blue: 0.13) // gold
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75) // silver
        case 3: return Color(red: 0.80, green: 0.50, blue: 0.20) // bronze
        default: return AppTheme.Colors.accent.opacity(0.6)
        }
    }
}
