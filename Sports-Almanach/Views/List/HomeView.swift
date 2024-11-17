//
//  HomeView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI
import Foundation

struct HomeView: View {
    
    @State private var showLoginView = false
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var navigateToLogin: Bool = false
    @State private var expandedSection: String?
    
    struct BannerImage: Identifiable, Hashable {
        let id = UUID()
        let imageName: String
    }
    
    let bannerImages = [
        BannerImage(imageName: "bannersports"),
        BannerImage(imageName: "boxen"),
        BannerImage(imageName: "golf"),
        BannerImage(imageName: "laufen"),
        BannerImage(imageName: "radfahren"),
        BannerImage(imageName: "schwimmen"),
        BannerImage(imageName: "tennis")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    LogoutButton(showLoginView: $showLoginView)
                    
                    AppName(title: "Sports Almanach")
                        .padding(.bottom, 54)
                    
                    AnimatedText()
                        .padding(.bottom, 24)
                    
                    DividerView()
                    
                    SectionListView(expandedSection: $expandedSection)
                    
                    DividerView()
                    
                    AutoScrollingBannerView(bannerImages: bannerImages)
                        .padding(.bottom, 60)
                }
                .navigationBarBackButtonHidden(true)
                .onChange(of: userViewModel.isLoggedIn) { _, newValue in
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
