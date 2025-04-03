//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

/// Zeigt Rangliste und Wettschein-Historie an
struct StatisticView: View {
    
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isLoadingRanks = true
    @State private var isLoadingBets = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 20) {
                    Title(title: "Rangliste")
                        .padding(.leading, 24)
                        .padding(.bottom, 16)
                    RankListView(profiles: userViewModel.rankedUsers)
                    
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                    
                    Title(title: "Wettscheine")
                        .padding(.leading, 24)
                        .padding(.bottom, 16)
                    
                    BetSlipsListView(betSlips: betViewModel.loadedBetSlips)
                }
            }
        }
        .task {
            // Lädt Daten beim Erscheinen der View
            await userViewModel.loadAndSortRankedUsers()
            await betViewModel.loadBetSlipHistory()
        }
    }
}

/// Zeigt die Rangliste der Benutzer an
struct RankListView: View {
    let profiles: [Profile]
    var body: some View {
        VStack() {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(profiles.enumerated()), id: \.element.id) { index, profile in
                        StatisticRankRow(
                            rank: index + 1,
                            profile: profile
                        )
                    }
                }
            }
        }
    }
}

/// Zeigt die Liste der Wettscheine an
struct BetSlipsListView: View {
    let betSlips: [BetSlip]
    var body: some View {
        VStack() {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(betSlips) { betSlip in
                        NavigationLink(destination: StatisticSlipDetailView(betSlip: betSlip)) {
                            StatisticSlipRow(betSlip: betSlip)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StatisticView()
        .environmentObject(BetViewModel())
        .environmentObject(UserViewModel())
}
