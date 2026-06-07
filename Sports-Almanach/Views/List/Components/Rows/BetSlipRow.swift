//
//  BetSlipRow.swift
//  Sports-Almanach
//

import SwiftUI

struct BetSlipRow: View {

    let index: Int
    let bet: Bet

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack {
                Text("\(index + 1).")
                    .font(AppTheme.Typography.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.accent)
                Text(bet.event.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Spacer()
                oddsChip
            }
            outcomeChip
        }
        .padding(AppTheme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
        )
        .appShadow(AppTheme.Shadow.small)
    }

    private var oddsChip: some View {
        Text(formatDecimal(bet.odds))
            .font(AppTheme.Typography.subheadline.monospacedDigit())
            .padding(.horizontal, AppTheme.Spacing.s)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.s, style: .continuous).fill(.white)
            )
            .foregroundStyle(.black)
    }

    private var outcomeChip: some View {
        Text(bet.userTip.displayName)
            .font(AppTheme.Typography.footnote.weight(.semibold))
            .padding(.horizontal, AppTheme.Spacing.s)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.s, style: .continuous).fill(outcomeColor.opacity(0.7))
            )
            .foregroundStyle(.white)
    }

    private var outcomeColor: Color {
        switch bet.userTip.stableID {
        case MatchOutcome.homeWin.rawValue: return AppTheme.Colors.homeWin
        case MatchOutcome.draw.rawValue:    return AppTheme.Colors.draw
        case MatchOutcome.awayWin.rawValue: return AppTheme.Colors.awayWin
        default:                            return AppTheme.Colors.info
        }
    }

    private func formatDecimal(_ value: Decimal) -> String {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f.string(from: value as NSDecimalNumber) ?? "\(value)"
    }
}

#if DEBUG
#Preview("BetSlipRow") {
    VStack(spacing: AppTheme.Spacing.m) {
        BetSlipRow(index: 0, bet: Mocks.bets[0])
        BetSlipRow(index: 1, bet: Mocks.bets[1])
    }
    .padding()
    .frame(maxHeight: .infinity)
    .appBackground(.gradient)
}
#endif
