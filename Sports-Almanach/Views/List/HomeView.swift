//
//  HomeView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var showLoginView = false
    @State private var navigateToLogin: Bool = false
    @State private var expandedSection: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    LogoutButton(showLoginView: $showLoginView)
                    Title(title: "Sports Almanach")
                        .padding(.bottom, 54)
                    AnimatedText()
                        .padding(.bottom, 24)
                    divider()
                    SectionListView(expandedSection: $expandedSection)
                    divider()
                        .padding(.bottom, 24)
                    AutoScrollingBannerView(bannerImages: Banner.defaultBanners)
                                     .padding(Edge.Set.bottom, 60)
                             }
                .navigationBarBackButtonHidden(true)
                .onChange(of: userViewModel.authState.isLoggedIn) { _, newValue in
                    if !newValue {
                        navigateToLogin = true
                    }
                }
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
        }
    }
    
    // MARK: - Local Helper
    private func divider() -> some View {
        Rectangle()
            .frame(height: 1)
            .frame(width: 340)
            .foregroundColor(.white)
    }
    
    struct LogoutButton: View {
        @EnvironmentObject var userViewModel: UserViewModel
        @Binding var showLoginView: Bool
        var body: some View {
            HStack {
                Spacer()
                Button(action: {
                    userViewModel.logout()
                    showLoginView = true
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.blue)
                        .padding(.top, 28)
                        .padding(.trailing, 38)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
