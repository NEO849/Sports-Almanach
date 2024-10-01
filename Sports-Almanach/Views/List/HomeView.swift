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
        
        ZStack {
             Image("hintergrund")
                 .resizable()
                 .scaledToFill()
                 .edgesIgnoringSafeArea(.all)

             VStack {
                 HStack {
                     Spacer()
                     Button(action: {
                         userViewModel.signOut()
                     }) {
                         Image(systemName: "rectangle.portrait.and.arrow.right")
                             .foregroundColor(.white)
                             .padding()
                     }
                 }
                 .padding()

                 Spacer()

                Text("HomeView")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .contentShape(Rectangle())
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
