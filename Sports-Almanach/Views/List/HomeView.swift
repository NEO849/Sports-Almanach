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
    @State private var navigateToLogin: Bool = false
    
    struct BannerImage: Identifiable {
        let id = UUID()
        let imageName: String
    }
    
    // Array der Banner-Bildern
    let bannerImages = [
        BannerImage(imageName: "bannersports"),
        BannerImage(imageName: "bannersports2"),
        BannerImage(imageName: "basketball"),
        BannerImage(imageName: "boxen"),
        BannerImage(imageName: "football"),
        BannerImage(imageName: "fussball"),
        BannerImage(imageName: "golf"),
        BannerImage(imageName: "laufen"),
        BannerImage(imageName: "radfahren"),
        BannerImage(imageName: "schwimmen"),
        BannerImage(imageName: "tennis"),
        BannerImage(imageName: "volleyball")
    ]
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        userViewModel.logout()  // Logout
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.blue)                    }
                    .padding(.trailing, 32)
                }
                .padding(.top, 48)
                Spacer()
            }
            VStack {
                Image("appname")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 32)
                    .padding(.bottom, 160)
                Spacer()
                
                BannerScrollView(bannerImages: bannerImages)
                                 .frame(height: 100)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: userViewModel.isLoggedIn) { isLoggedIn in
            if !isLoggedIn {
                navigateToLogin = true  // Nicht Angemeldet -> LoginView
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
        }
    }
}

// Separater für ScrollView
struct BannerScrollView: View {
    let bannerImages: [HomeView.BannerImage]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(bannerImages) { image in
                    StyledImageView(imageName: image.imageName)
                }
            }
            .padding()
        }
    }
}

// Separater für BannerScrollView
struct StyledImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 80)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 1)
            )
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
