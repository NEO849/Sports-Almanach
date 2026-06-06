//
//  HomeView.swift
//  Sports-Almanach
//
//  Branded landing screen — hero, animated tagline, info sections, banner.
//  Replaces the legacy implementation that nested a NavigationStack inside
//  ContentView's existing NavigationStack (caused subtle navigation bugs).
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var session: AppSession
    @State private var expandedSection: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    Title(title: "Sports Almanach")
                        .padding(.top, AppTheme.Spacing.xl)

                    if let profile = userVM.profile {
                        balanceBadge(profile: profile)
                    }

                    AnimatedText()

                    SectionListView(expandedSection: $expandedSection)
                        .padding(.horizontal, AppTheme.Spacing.l)

                    AutoScrollingBannerView(bannerImages: Banner.defaultBanners)
                        .padding(.vertical, AppTheme.Spacing.m)
                }
                .padding(.bottom, AppTheme.Spacing.xxl)
            }
            .scrollIndicators(.hidden)
            .appBackground(.gradient)
            .toolbar { toolbar }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                userVM.logout()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            .accessibilityLabel("Abmelden")
        }
    }

    private func balanceBadge(profile: Profile) -> some View {
        HStack(spacing: AppTheme.Spacing.s) {
            Image(systemName: "wallet.pass.fill")
                .foregroundStyle(AppTheme.Colors.accent)
            VStack(alignment: .leading) {
                Text("Hallo, \(profile.username)")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                Text(userVM.balance.formatted())
                    .font(AppTheme.Typography.title2.monospacedDigit())
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(AppTheme.Motion.smooth, value: userVM.balance)
            }
            Spacer()
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
        .padding(.horizontal, AppTheme.Spacing.l)
    }
}
