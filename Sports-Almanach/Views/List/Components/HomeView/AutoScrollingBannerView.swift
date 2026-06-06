//
//  AutoScrollingBannerView.swift
//  Sports-Almanach
//
//  Auto-scrolling marquee of sport banners. Re-implemented on top of a
//  TimelineView instead of the legacy 0.02s Timer (which leaked when the
//  view re-rendered and kept ticking even after the view disappeared).
//

import SwiftUI

struct AutoScrollingBannerView: View {

    let bannerImages: [Banner]
    private let cardWidth: CGFloat = 110
    private let spacing: CGFloat = AppTheme.Spacing.m
    /// Pixels per second.
    private let pointsPerSecond: CGFloat = 30

    var body: some View {
        TimelineView(.animation) { context in
            GeometryReader { geo in
                let totalWidth = (cardWidth + spacing) * CGFloat(bannerImages.count)
                let elapsed = context.date.timeIntervalSinceReferenceDate
                let translate = -(CGFloat(elapsed) * pointsPerSecond).truncatingRemainder(dividingBy: totalWidth)
                HStack(spacing: spacing) {
                    ForEach(loopedBanners, id: \.self) { banner in
                        StyledBannerImageView(imageName: banner.imageName)
                            .frame(width: cardWidth, height: 80)
                    }
                }
                .offset(x: translate)
                .frame(width: geo.size.width, alignment: .leading)
                .clipped()
            }
            .frame(height: 90)
        }
        .accessibilityHidden(true)
    }

    private var loopedBanners: [Banner] {
        // Repeating once is enough — the TimelineView's truncated offset
        // wraps modulo the original width so we only need two copies on
        // screen at any moment.
        bannerImages + bannerImages
    }
}

struct StyledBannerImageView: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
            )
            .appShadow(AppTheme.Shadow.small)
    }
}
