//
//  BetView.swift
//  Sports-Almanach
//
//  Lists the user's currently picked events and lets them open the BetSlip
//  sheet. No longer instantiates its own BetViewModel — the legacy `BetView`
//  created a second @StateObject parallel to the EnvironmentObject from App,
//  causing diverging state between the two.
//

import SwiftUI

struct BetView: View {

    @EnvironmentObject private var betVM: BetViewModel
    @EnvironmentObject private var eventVM: EventViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @State private var presentingSlip = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                betCandidatesList
            }
            .appBackground(.gradient)
            .navigationTitle("Wetten")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $presentingSlip) {
                BetSlipView()
                    .presentationDetents([.large, .fraction(0.85)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: AppTheme.Spacing.s) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Kontostand")
                    .font(AppTheme.Typography.footnote)
                    .foregroundStyle(.white.opacity(0.7))
                Text(userVM.balance.formatted())
                    .font(AppTheme.Typography.title3.monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(AppTheme.Motion.smooth, value: userVM.balance)
            }

            Spacer()

            Button {
                presentingSlip = true
            } label: {
                Label("Wettschein", systemImage: "ticket.fill")
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppTheme.Spacing.l)
                    .padding(.vertical, AppTheme.Spacing.s)
                    .background(
                        Capsule().fill(AppTheme.Gradients.brand)
                    )
                    .accentGlow(opacity: 0.4)
            }
            .buttonStyle(PressableButtonStyle())
            .accessibilityLabel("Wettschein öffnen")
        }
        .padding(.horizontal, AppTheme.Spacing.l)
        .padding(.vertical, AppTheme.Spacing.m)
    }

    @ViewBuilder
    private var betCandidatesList: some View {
        if eventVM.selectedEvents.isEmpty {
            ContentUnavailableView {
                Label("Noch keine Events ausgewählt", systemImage: "bullseye")
                    .foregroundStyle(.white)
            } description: {
                Text("Wähle Events im Events-Tab aus, um Wetten zu platzieren.")
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.top, AppTheme.Spacing.xxxl)
            Spacer()
        } else {
            List {
                ForEach(eventVM.selectedEvents) { event in
                    BetRow(event: event)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task { await eventVM.removeFromSelection(event) }
                            } label: { Label("Löschen", systemImage: "trash") }
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

#if DEBUG
#Preview("Wetten") {
    BetView().previewEnvironment()
}
#endif
