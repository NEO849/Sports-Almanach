//
//  EventDetailView.swift
//  Sports-Almanach
//
//  Rich detail page for an event. Replaces the legacy layout that hard-coded
//  340×140 frames and relied on a typo'd `Image("Terrorimage")` fallback.
//

import SwiftUI
import WebKit

struct EventDetailView: View {

    let event: Event

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.l) {
                hero
                titleBlock
                teamsBlock
                if let urlString = event.videoURL, let url = URL(string: urlString) {
                    videoPlayer(url: url)
                } else {
                    noVideoFallback
                }
            }
            .padding(AppTheme.Spacing.l)
        }
        .scrollIndicators(.hidden)
        .appBackground(.gradient)
        .navigationTitle("Event-Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var hero: some View {
        if let urlString = event.thumbnail, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color.black.opacity(0.4)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous))
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(event.name)
                .font(AppTheme.Typography.title3.bold())
                .foregroundStyle(.white)
            HStack(spacing: AppTheme.Spacing.s) {
                Label(SportEventUtils.formattedDate(for: event), systemImage: "calendar")
                Label(SportEventUtils.formattedTime(for: event), systemImage: "clock")
            }
            .font(AppTheme.Typography.subheadline)
            .foregroundStyle(.white.opacity(0.8))
            Label(event.stadium, systemImage: "mappin.and.ellipse")
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            statusBadge
        }
    }

    private var statusBadge: some View {
        Text(event.status.displayName)
            .font(AppTheme.Typography.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, AppTheme.Spacing.s)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .background(Capsule().fill(event.status.color))
    }

    private var teamsBlock: some View {
        HStack(spacing: AppTheme.Spacing.l) {
            teamColumn(name: event.homeTeam, badge: event.homeTeamBadge, score: event.homeScore, label: "Heim")
            Spacer()
            VStack {
                Text(":")
                    .font(AppTheme.Typography.largeTitle.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.6))
            }
            Spacer()
            teamColumn(name: event.awayTeam, badge: event.awayTeamBadge, score: event.awayScore, label: "Auswärts")
        }
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
        )
        .appShadow(AppTheme.Shadow.medium)
    }

    private func teamColumn(name: String, badge: String?, score: Int?, label: String) -> some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Text(label)
                .font(AppTheme.Typography.caption.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.accent)
            if let badge, let url = URL(string: badge) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Image(systemName: "shield")
                        .foregroundStyle(.white.opacity(0.3))
                }
                .frame(width: 60, height: 60)
            }
            Text(name)
                .font(AppTheme.Typography.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(score.map(String.init) ?? "—")
                .font(AppTheme.Typography.title.monospacedDigit())
                .foregroundStyle(score == nil ? .white.opacity(0.4) : AppTheme.Colors.accent)
        }
        .frame(maxWidth: .infinity)
    }

    private func videoPlayer(url: URL) -> some View {
        WebView(url: url)
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                    .strokeBorder(AppTheme.Colors.accent.opacity(0.6), lineWidth: 1)
            )
    }

    private var noVideoFallback: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Image(systemName: "video.slash")
                .font(.system(size: 36))
                .foregroundStyle(.white.opacity(0.4))
            Text("Kein Video verfügbar")
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
}

#if DEBUG
#Preview("Event-Detail") {
    NavigationStack { EventDetailView(event: Mocks.events[0]) }
        .previewEnvironment()
}
#endif
