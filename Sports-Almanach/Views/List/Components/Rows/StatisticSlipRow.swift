//
//  StatisticSlipRow.swift
//  Sports-Almanach
//

import SwiftUI

struct StatisticSlipRow: View {

    let betSlip: BetSlip

    var body: some View {
        HStack(spacing: AppTheme.Spacing.s) {
            Text("#\(betSlip.slipNumber)")
                .font(AppTheme.Typography.headline.monospacedDigit())
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(dateString)
                    .font(AppTheme.Typography.footnote)
                    .foregroundStyle(.white.opacity(0.7))
                Text("\(betSlip.bets.count) Wetten · \(betSlip.stake.formatted())")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.white)
            }
            Spacer()
            statusBadge
            payoutLabel
        }
        .padding(AppTheme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                .strokeBorder(AppTheme.Colors.accent.opacity(0.4), lineWidth: 1)
        )
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f.string(from: betSlip.createdAt)
    }

    private var statusBadge: some View {
        Text(betSlip.status.displayName)
            .font(AppTheme.Typography.caption.weight(.semibold))
            .padding(.horizontal, AppTheme.Spacing.s)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .foregroundStyle(.white)
            .background(Capsule().fill(badgeColor))
    }

    @ViewBuilder
    private var payoutLabel: some View {
        if let win = betSlip.winAmount, win.isPositive {
            Text("+\(win.formatted())")
                .font(AppTheme.Typography.subheadline.monospacedDigit().bold())
                .foregroundStyle(AppTheme.Colors.success)
        }
    }

    private var badgeColor: Color {
        switch betSlip.status {
        case .won:          return AppTheme.Colors.success
        case .partiallyWon: return AppTheme.Colors.success.opacity(0.7)
        case .lost:         return AppTheme.Colors.destructive
        case .pending:      return AppTheme.Colors.pending
        }
    }
}
