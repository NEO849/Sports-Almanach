//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct StatisticsView: View {
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Text("In Progress, Rangliste der besten Spieler und deine Wettscheine einsehen")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .contentShape(Rectangle())
        }
        
    }
}

#Preview {
    StatisticsView()
}
