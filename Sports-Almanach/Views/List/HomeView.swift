//
//  HomeView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("splashsporthintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Willkommen im Home-Bereich!")
                        .font(.largeTitle)
                    
                }
            }
            .navigationTitle("Home")
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
