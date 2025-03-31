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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 20) {
                    RankListView(profiles: userViewModel.rankedUsers)
                    DividerView()
                    BetSlipsListView(betSlips: betViewModel.loadedBetSlips)
                }
                .padding(.vertical)
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
        VStack(alignment: .leading, spacing: 20) {
            Text("Rangliste")
                .font(.title)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(profiles.enumerated()), id: \.element.id) { index, profile in
                        StatisticRankRow(
                            rank: index + 1,
                            profile: profile
                        )
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
    }
}

/// Zeigt die Liste der Wettscheine an
struct BetSlipsListView: View {
    let betSlips: [BetSlip]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Wettscheine")
                .font(.title)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(betSlips) { betSlip in
                        NavigationLink(destination: StatisticSlipDetailView(betSlip: betSlip)) {
                            StatisticSlipRow(betSlip: betSlip)
                        }
                    }
                }
                .padding(.horizontal)
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
