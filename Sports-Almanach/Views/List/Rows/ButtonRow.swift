//
//  ButtonRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.10.24.
//

import Foundation
import SwiftUI

struct ButtonRow: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("--->> Hinzufügen zur Wette <<---")
                .font(.subheadline)
                .foregroundColor(.blue)
           
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange, lineWidth: 2)
                        .frame(width: 300)
                )
        }
        .frame(height: 42)
        .buttonStyle(.borderless)
    }
}

#Preview {
    ButtonRow(action: {print("Button gedrückt!") })
}
