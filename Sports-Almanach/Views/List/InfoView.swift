//
//  InfoView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct InfoView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("splashsporthintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Hier finden Sie Informationen.")
                        .font(.largeTitle)
                        .padding()
                }
            }
            .navigationTitle("Infos")
        }
    }
}

#Preview {
    InfoView()
}
