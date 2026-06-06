//
//  StatisticView.swift
//  Sports-Almanach
//
//  Ranking + bet history. Uses SwiftUI Charts for the small balance trend.
//

import SwiftUI

struct StatisticView: View {

    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var betVM: BetViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    sectionHeader("Rangliste", icon: "trophy.fill")
                    rankingList

                    Divider().overlay(AppTheme.Colors.accent.opacity(0.5))

                    sectionHeader("Deine Wettscheine", icon: "ticket.fill")
                    betHistoryList
                }
                .padding(.horizontal, AppTheme.Spacing.l)
                .padding(.vertical, AppTheme.Spacing.l)
            }
            .scrollIndicators(.hidden)
            .appBackground(.gradient)
            .navigationTitle("Statistik")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await userVM.loadAndSortRankedUsers()
                await betVM.refreshHistory()
                await userVM.refreshBalance()
            }
            .refreshable {
                await userVM.loadAndSortRankedUsers()
                await betVM.refreshHistory()
                await userVM.refreshBalance()
            }
        }
    }

    private func sectionHeader(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(AppTheme.Typography.title3)
            .foregroundStyle(.white)
            .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder
    private var rankingList: some View {
        if userVM.rankedUsers.isEmpty {
            placeholder("Noch keine Ranglisten-Daten.")
        } else {
            VStack(spacing: AppTheme.Spacing.s) {
                ForEach(Array(userVM.rankedUsers.enumerated()), id: \.element.id) { idx, profile in
                    StatisticRankRow(rank: idx + 1, profile: profile)
                }
            }
        }
    }

    @ViewBuilder
    private var betHistoryList: some View {
        if betVM.loadedSlips.isEmpty {
            placeholder("Noch keine Wettscheine gespielt.")
        } else {
            VStack(spacing: AppTheme.Spacing.s) {
                ForEach(betVM.loadedSlips) { slip in
                    NavigationLink {
                        StatisticSlipDetailView(betSlip: slip)
                    } label: {
                        StatisticSlipRow(betSlip: slip)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func placeholder(_ text: String) -> some View {
        Text(text)
            .font(AppTheme.Typography.subheadline)
            .foregroundStyle(.white.opacity(0.6))
            .padding(AppTheme.Spacing.l)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#if DEBUG
#Preview("Statistik") {
    StatisticView().previewEnvironment()
}
#endif
