//
//  BetSlipView.swift
//  Sports-Almanach
//
//  Sheet UI for staking and submitting a slip. Hardened against the legacy
//  bugs:
//  - Slider range now safely clamps when balance == 0 (legacy crashed with
//    Range 0...0).
//  - Place button awaits the real async result instead of the legacy
//    fire-and-forget `syncPlaceBets` which always returned `true`.
//

import SwiftUI

struct BetSlipView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var betVM: BetViewModel
    @EnvironmentObject private var userVM: UserViewModel

    @State private var localStake: Double = 0
    @State private var alertMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.l) {
                slipHeader
                slipList
                stakeBlock
                placeButton
            }
            .padding(.horizontal, AppTheme.Spacing.l)
            .padding(.vertical, AppTheme.Spacing.l)
            .appBackground(.gradient)
            .navigationTitle("Wettschein")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                }
            }
            .alert("Wette nicht möglich",
                   isPresented: Binding(get: { alertMessage != nil },
                                        set: { _ in alertMessage = nil })) {
                Button("OK", role: .cancel) {}
            } message: { Text(alertMessage ?? "") }
        }
    }

    private var slipHeader: some View {
        Label("Wettschein", systemImage: "ticket.fill")
            .font(AppTheme.Typography.title3)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
    }

    private var slipList: some View {
        Group {
            if betVM.draftBets.isEmpty {
                ContentUnavailableView("Wettschein ist leer",
                                       systemImage: "tray",
                                       description: Text("Füge Wetten aus dem Wett-Tab hinzu."))
                    .foregroundStyle(.white)
            } else {
                List {
                    ForEach(Array(betVM.draftBets.enumerated()), id: \.element.id) { idx, bet in
                        BetSlipRow(index: idx, bet: bet)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    betVM.removeDraftBet(eventID: bet.event.eventID)
                                } label: { Label("Entfernen", systemImage: "trash") }
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }

    private var stakeBlock: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            HStack {
                Text("Einsatz")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                Spacer()
                Text(currentStakeMoney.formatted())
                    .font(AppTheme.Typography.headline.monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(AppTheme.Motion.smooth, value: localStake)
            }
            Slider(value: $localStake,
                   in: 0...max(Double(truncating: userVM.balance.amount as NSNumber), 1),
                   step: 1.0) { _ in
                betVM.setStake(currentStakeMoney)
            }
            .tint(AppTheme.Colors.accent)
            .disabled(userVM.balance.isZero)

            HStack {
                metric("Gesamtquote", value: formatDecimal(betVM.totalOdds))
                Spacer()
                metric("Möglicher Gewinn", value: betVM.potentialWin.formatted())
            }
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

    private var placeButton: some View {
        PrimaryActionButton(
            title: "Wette platzieren",
            isEnabled: canPlace,
            isLoading: betVM.isPlacing
        ) {
            Task { await place() }
        }
    }

    private var canPlace: Bool {
        !betVM.draftBets.isEmpty
        && currentStakeMoney >= AppConstants.Balances.minimumStake
        && currentStakeMoney <= userVM.balance
    }

    private var currentStakeMoney: Money {
        Money(Decimal(localStake))
    }

    private func formatDecimal(_ value: Decimal) -> String {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f.string(from: value as NSDecimalNumber) ?? "\(value)"
    }

    private func place() async {
        let succeeded = await betVM.placeSlip()
        if succeeded {
            dismiss()
        } else {
            alertMessage = betVM.lastError ?? "Wette konnte nicht platziert werden."
            betVM.clearError()
        }
    }
}
