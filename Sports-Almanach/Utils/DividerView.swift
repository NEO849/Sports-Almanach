//
//  DividerView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct DividerView: View {
    var width: CGFloat = 340
    var color: Color = .white
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .frame(width: width)
            .foregroundColor(color)
            .padding(.bottom, 6)
    }
}

struct VerticalDividerView: View {
    var width: CGFloat = 1
    var color: Color = .white
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width)
            .edgesIgnoringSafeArea(.vertical)
    }
}

// MARK: - Preview
struct DividerViews_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 160) {
                VStack {
                    Text("Horizontaler Divider")
                        .foregroundColor(.orange)
                        .font(.title2)
                    DividerView()
                }
                VStack {
                    Text("Vertikaler Divider")
                        .foregroundColor(.orange)
                        .font(.title2)
                    HStack {
                        Text("Links")
                            .foregroundColor(.orange)
                            .padding()
                        VerticalDividerView()
                        Text("Rechts")
                            .foregroundColor(.orange)
                            .padding()
                    }
                }
            }
        }
    }
}
