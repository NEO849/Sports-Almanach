//
//  AutoScrollingBannerView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.11.24.
//

import SwiftUI

struct AutoScrollingBannerView: View {
    let bannerImages: [HomeView.BannerImage]
    @State private var offset: CGFloat = 0
    @State private var timer: Timer?
    
    private var repeatedBannerImages: [HomeView.BannerImage] {
        Array(repeating: bannerImages, count: 50).flatMap { $0 }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(repeatedBannerImages, id: \.self) { image in
                        StyledBannerImageView(imageName: image.imageName)
                            .frame(width: 100, height: 80)
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width * CGFloat(repeatedBannerImages.count), alignment: .leading)
                .offset(x: offset)
                .onAppear {
                    startTimerBanner(geometry: geometry)
                }
                .onDisappear {
                    stopTimerBanner()
                }
            }
        }
    }
    
    private func startTimerBanner(geometry: GeometryProxy) {
        stopTimerBanner()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            DispatchQueue.main.async {
                offset -= 1
                if offset <= -geometry.size.width * CGFloat(bannerImages.count) {
                    offset = 0
                }
            }
        }
    }
    
    private func stopTimerBanner() {
        timer?.invalidate()
        timer = nil
    }
}

struct StyledBannerImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 90, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            )
            .cornerRadius(10)
            .shadow(color: .orange, radius: 4, x: 3, y: 3)
    }
}
