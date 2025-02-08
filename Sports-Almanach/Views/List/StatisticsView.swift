//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedBet: Bet?
    @State private var showBetDetails = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
