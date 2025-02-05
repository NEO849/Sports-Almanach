//
//  HomeView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showLoginView = false
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
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
                    
                    DividerView()
                    
                    SectionListView(expandedSection: $expandedSection)
                    
                    DividerView()
                    
                    AutoScrollingBannerView(bannerImages: Banner.defaultBanners)
                                     .padding(Edge.Set.bottom, 60)
                             }
                .navigationBarBackButtonHidden(true)
                // Beobachtet den AuthState
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
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
