//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var betViewModel: BetViewModel
    @State private var selectedBet: Bet?
    @State private var showBetDetails = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                StatisticsContent()
            }
            .navigationTitle("Statistiken")
        }
    }
}

// MARK: - Helper Views
/// Statistik-Inhalt (Platzhalter)
private struct StatisticsContent: View {
    var body: some View {
        VStack {
            Text("Detaillierte Statistiken folgen...")
                .font(.title2)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    StatisticsView()
        .environmentObject(BetViewModel())
}
