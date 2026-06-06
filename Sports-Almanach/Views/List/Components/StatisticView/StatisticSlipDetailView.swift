//
//  StatisticSlipDetailView.swift
//  Sports-Almanach
//
//  Detail screen for a single BetSlip. Stake/payout use the new Money type;
//  status uses the BetSlipStatus enum so "pending" doesn't render as "lost".
//

import SwiftUI

struct StatisticSlipDetailView: View {

    let betSlip: BetSlip

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.l) {
                heroHeader
                summaryMetrics
                betList
            }
            .padding(.horizontal, AppTheme.Spacing.l)
            .padding(.vertical, AppTheme.Spacing.l)
        }
        .scrollIndicators(.hidden)
        .appBackground(.gradient)
        .navigationTitle("Wettschein #\(betSlip.slipNumber)")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(formattedDate)
                    .font(AppTheme.Typography.footnote)
                    .foregroundStyle(.white.opacity(0.7))
                Text(betSlip.status.displayName)
                    .font(AppTheme.Typography.title2.weight(.bold))
                    .foregroundStyle(statusColor)
            }
            Spacer()
            if let win = betSlip.winAmount, win.isPositive {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Gewinn")
                        .font(AppTheme.Typography.footnote)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(win.formatted())
                        .font(AppTheme.Typography.title2.monospacedDigit())
                        .foregroundStyle(AppTheme.Colors.success)
                }
            }
        }
    }

    private var summaryMetrics: some View {
        HStack {
            metric("Einsatz", value: betSlip.stake.formatted())
            Spacer()
            metric("Gesamtquote", value: formatDecimal(betSlip.totalOdds))
            Spacer()
            metric("Wetten", value: "\(betSlip.bets.count)")
        }
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
        )
        .appShadow(AppTheme.Shadow.medium)
    }

    private var betList: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            ForEach(Array(betSlip.bets.enumerated()), id: \.element.id) { idx, bet in
                BetSlipRow(index: idx, bet: bet)
            }
        }
    }

    private func metric(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(AppTheme.Typography.headline.monospacedDigit())
                .foregroundStyle(.white)
        }
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .short
        return f.string(from: betSlip.createdAt)
    }

    private var statusColor: Color {
        switch betSlip.status {
        case .won:          return AppTheme.Colors.success
        case .partiallyWon: return AppTheme.Colors.success.opacity(0.8)
        case .lost:         return AppTheme.Colors.destructive
        case .pending:      return AppTheme.Colors.pending
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
#Preview("Wettschein-Detail") {
    NavigationStack { StatisticSlipDetailView(betSlip: Mocks.betSlips[0]) }
        .previewEnvironment()
}
#endif
