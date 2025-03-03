//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

// MARK: - StatisticsView
// Hauptview für die Statistik-Funktionalität
// Implementiert MVVM-Pattern mit ViewModels für Geschäftslogik
struct StatisticsView: View {
    
    // MARK: - Dependencies
    // ViewModels werden via Environment injection bereitgestellt
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    // MARK: - State Properties
    // Lokale States für UI-Interaktionen
    @State private var selectedBet: Bet?
    @State private var showBetDetails = false
    
    // MARK: - Properties
    // Environment Objects für MVVM Pattern - ermöglichen reaktive Updates
    // State Management für lokale UI-Zustände

    var body: some View {
        NavigationStack {
            ZStack {
                // Performance-Optimierung: Hintergrundbild
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Hauptinhalt
                Text("Comin Soon, Rangliste und \n Wettscheine anzeigen")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .contentShape(Rectangle())
            }
            
        }
    }

    // MARK: - Preview
    struct StatisticsView_Previews: PreviewProvider {
        static var previews: some View {
            StatisticsView()
                .environmentObject(BetViewModel())
                .environmentObject(UserViewModel())
        }
    }
}
