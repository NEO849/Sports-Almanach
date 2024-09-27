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
         
                  VStack {
                      Text("Willkommen im Home-Bereich!")
                          .font(.largeTitle)
                  }
              
              .navigationBarBackButtonHidden(true)
              .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: {
                          userViewModel.signOut()
                      }) {
                          Image(systemName: "rectangle.portrait.and.arrow.right")
                              .foregroundColor(.red)
                      }
                  }
              }
          }
      }
  }



#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
