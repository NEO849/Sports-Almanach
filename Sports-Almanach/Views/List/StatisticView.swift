//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct StatisticView: View {
    
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var betSlips: [BetSlip] = []
    var profiles: [Profile] = []
    @State private var showBetDetails: BetSlip?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Text("Coming Soon, Rangliste und \n     Wettscheine anzeigen")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StatisticView(
        betSlips: Mocks.betSlips,
        profiles: Mocks.profiles
    )
    .environmentObject(BetViewModel())
    .environmentObject(UserViewModel())
}
