//
//  DividerView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .frame(width: 340)
            .foregroundColor(.white)
            .padding(.bottom, 6)
    }
}
