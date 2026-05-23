//
//  BetRow.swift
//  Sports-Almanach
//
//  Row that lets the user pick a 1/X/2 outcome for a selected event and add
//  it to the slip. The legacy code mutated EventViewModel.selectedEvents
//  inline from inside a swipe button — that side-effect now goes through
//  the BetViewModel which is the authoritative draft owner.
//

import SwiftUI

struct BetRow: View {

    let event: Event

    @EnvironmentObject private var betVM: BetViewModel
    @EnvironmentObject private var eventVM: EventViewModel

    @State private var selectedOutcome: MatchOutcome?
    @State private var showDuplicateAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            header
            oddsGrid
            addToSlipButton
        }
        .padding(AppTheme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .strokeBorder(AppTheme.Colors.accent.opacity(0.45), lineWidth: 1)
        )
        .alert("Wette existiert bereits", isPresented: $showDuplicateAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Components

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(event.name)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
                .lineLimit(2)
            Text("\(SportEventUtils.formattedDate(for: event)) · \(SportEventUtils.formattedTime(for: event))")
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.accent)
        }
    }

    private var oddsGrid: some View {
        let bundle = OddsCalculator.odds(homeScore: event.homeScore, awayScore: event.awayScore)
        return VStack(spacing: AppTheme.Spacing.xs) {
            outcomeRow(.homeWin, odds: bundle.homeWin)
            outcomeRow(.draw, odds: bundle.draw)
            outcomeRow(.awayWin, odds: bundle.awayWin)
        }
    }

    private func outcomeRow(_ outcome: MatchOutcome, odds: Decimal) -> some View {
        let isSelected = selectedOutcome == outcome
        return Button {
            selectedOutcome = isSelected ? nil : outcome
        } label: {
            HStack {
                Circle()
                    .fill(outcome.swatch)
                    .frame(width: 12, height: 12)
                Text(outcome.displayName)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.white)
                Spacer()
                Text(formatted(odds))
                    .font(AppTheme.Typography.body.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.85))
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? AppTheme.Colors.accent : .white.opacity(0.4))
            }
            .padding(AppTheme.Spacing.s)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.s, style: .continuous)
                    .fill(isSelected ? AppTheme.Colors.accent.opacity(0.18) : Color.black.opacity(0.18))
            )
        }
        .buttonStyle(.plain)
    }

    private var addToSlipButton: some View {
        Button {
            addToSlip()
        } label: {
            HStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: "plus.circle.fill")
                Text("Zum Wettschein")
                    .font(AppTheme.Typography.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.vertical, AppTheme.Spacing.s)
            .frame(maxWidth: .infinity)
            .background(
                Capsule().fill(selectedOutcome == nil
                               ? AppTheme.Colors.accent.opacity(0.35)
                               : AppTheme.Colors.accent)
            )
        }
        .disabled(selectedOutcome == nil)
        .accessibilityHint("Wette zum Wettschein hinzufügen")
    }

    private func addToSlip() {
        guard let outcome = selectedOutcome else { return }
        if betVM.draftBets.contains(where: { $0.event.eventID == event.id }) {
            showDuplicateAlert = true
            return
        }
        let bundle = OddsCalculator.odds(homeScore: event.homeScore, awayScore: event.awayScore)
        let odds: Decimal = {
            switch outcome {
            case .homeWin: return bundle.homeWin
            case .draw:    return bundle.draw
            case .awayWin: return bundle.awayWin
            }
        }()
        let bet = Bet(
            event: event.snapshot,
            userTip: AnyOutcome(outcome),
            odds: odds
        )
        betVM.addDraftBet(bet)
        Task { await eventVM.removeFromSelection(event) }
        selectedOutcome = nil
    }

    private func formatted(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: value as NSDecimalNumber) ?? "\(value)"
    }
}
