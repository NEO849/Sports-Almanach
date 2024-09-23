//
//  FavoriteView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct FavoriteView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("splashsporthintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Hier werden ihre Favoriten Events gespeichert.")
                        .font(.largeTitle)
                        .padding()
                }
            }
            .navigationTitle("Favorits")
        }
    }
}

#Preview {
    FavoriteView()
}
