//
//  AppName.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct AppName: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.custom("Helvetica Neue Bold Italic", size: 32))
            .foregroundColor(.white)
            .shadow(color: .orange, radius: 2, x: 6, y: 10)
            .shadow(color: .white, radius: 4, x: 3, y: 3)
            .shadow(color: .orange, radius: 4, x: 0, y: 0)
    }
}
