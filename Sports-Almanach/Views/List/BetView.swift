//
//  BetView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct BetView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        
        ZStack {
            Image("splashsporthintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Wettoptionen werden hier angezeigt.")
                    .font(.largeTitle)
                    .padding()
                /// TO DO
            }
        }
    }
}

#Preview {
    BetView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
