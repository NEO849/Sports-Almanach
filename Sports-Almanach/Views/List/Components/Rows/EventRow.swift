//
//  EventRow.swift
//  Sports-Almanach
//
//  Card-style row for the event list. Uses new EventStatus + AsyncImage with
//  graceful loading, plus a swipe-leading "add to bet selection" action.
//

import SwiftUI

struct EventRow: View {

    let event: Event

    @EnvironmentObject private var eventVM: EventViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            thumbnail
            metaRow
        }
        .padding(AppTheme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
        )
        .appShadow(AppTheme.Shadow.medium)
        .padding(.vertical, AppTheme.Spacing.xs)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                Task { await eventVM.addToSelection(event) }
            } label: {
                Label("Zur Wette", systemImage: "plus.circle.fill")
            }
            .tint(AppTheme.Colors.success)
        }
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let urlString = event.thumbnail, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .empty:
                    ProgressView().tint(AppTheme.Colors.accent)
                        .frame(maxWidth: .infinity, minHeight: 120)
                case .failure:
                    placeholderImage
                @unknown default:
                    placeholderImage
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 160)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous))
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "sportscourt")
            .font(.system(size: 40))
            .foregroundStyle(.white.opacity(0.4))
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(.black.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous))
    }

    private var metaRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(shortName(event.name, limit: 36))
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text("\(SportEventUtils.formattedDate(for: event)) · \(SportEventUtils.formattedTime(for: event))")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            Spacer()
            statusBadge
        }
    }

    private var statusBadge: some View {
        Text(event.status.displayName)
            .font(AppTheme.Typography.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, AppTheme.Spacing.s)
            .padding(.vertical, AppTheme.Spacing.xxs)
            .background(
                Capsule().fill(event.status.color)
            )
    }

    private func shortName(_ name: String, limit: Int) -> String {
        if name.count > limit {
            return String(name.prefix(limit)) + "…"
        }
        return name
    }
}

#if DEBUG
#Preview("EventRow") {
    EventRow(event: Mocks.events[0])
        .padding()
        .frame(maxHeight: .infinity)
        .appBackground(.gradient)
        .previewEnvironment()
}
#endif
