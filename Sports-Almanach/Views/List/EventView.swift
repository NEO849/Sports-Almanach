//
//  EventView.swift
//  Sports-Almanach
//
//  Browse fixtures for a chosen league + season, drill into details, or add
//  to the bet candidates. The legacy file had a generic SelectionMenu inline
//  and a hard-coded id=4328 league filter; both gone now.
//

import SwiftUI

struct EventView: View {

    @EnvironmentObject private var eventVM: EventViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                contentList
                if eventVM.isLoading && eventVM.events.isEmpty {
                    ProgressView("Lade Events…")
                        .tint(AppTheme.Colors.accent)
                        .foregroundStyle(.white)
                }
            }
            .appBackground(.photographic)
            .navigationTitle("Events")
            .toolbar { toolbar }
            .task {
                if eventVM.events.isEmpty {
                    await eventVM.reload()
                }
            }
            .refreshable {
                await eventVM.reload()
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section("Liga") {
                    ForEach(League.allCases) { league in
                        Button(league.rawValue) {
                            eventVM.selectedLeague = league
                            Task { await eventVM.reload() }
                        }
                    }
                }
                Section("Saison") {
                    ForEach(Season.allCases) { season in
                        Button(season.rawValue) {
                            eventVM.selectedSeason = season
                            Task { await eventVM.reload() }
                        }
                    }
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            .accessibilityLabel("Filter")
        }
    }

    private var contentList: some View {
        List {
            Section {
                ForEach(eventVM.events) { event in
                    NavigationLink {
                        EventDetailView(event: event)
                    } label: {
                        EventRow(event: event)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            } header: {
                filterChips
                    .padding(.vertical, AppTheme.Spacing.s)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var filterChips: some View {
        HStack(spacing: AppTheme.Spacing.s) {
            chip(symbol: "trophy", text: eventVM.selectedLeague.shortName)
            chip(symbol: "calendar", text: eventVM.selectedSeason.rawValue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func chip(symbol: String, text: String) -> some View {
        Label(text, systemImage: symbol)
            .font(AppTheme.Typography.footnote.weight(.semibold))
            .padding(.horizontal, AppTheme.Spacing.m)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(
                Capsule().fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule().strokeBorder(AppTheme.Colors.accent.opacity(0.55), lineWidth: 1)
            )
            .foregroundStyle(.white)
    }
}
