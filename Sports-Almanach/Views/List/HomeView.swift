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
    @State private var textOffset: CGFloat = 0
    @State private var expandedSection: String?
    
    struct BannerImage: Identifiable, Hashable {
        let id = UUID()
        let imageName: String
    }
    
    let bannerImages = [
        BannerImage(imageName: "bannersports"),
        BannerImage(imageName: "boxen"),
        BannerImage(imageName: "football"),
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
                    
                    ZStack {
                        Text("Sports Almanach")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 34)
                    
                    ZStack {
                        AnimatedText()
                    }
                    .padding(.bottom, 20)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 10) {
                        SectionView(sectionName: "Events", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                        SectionView(sectionName: "Details", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                        SectionView(sectionName: "Wetten", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                        SectionView(sectionName: "Statistiken", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                    }
                    .padding(.vertical, 24)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                        .padding(.bottom, 12)
                    
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
    
    struct AnimatedText: View {
        @State private var textOffset: CGFloat = UIScreen.main.bounds.width
        
        var body: some View {
            
            VStack(spacing: 20) {
                Rectangle()
                    .cornerRadius(10)
                    .background(
                        Color.white
                            .opacity(0.9)
                            .shadow(radius: 10)
                    )
                    .padding(.horizontal, 10)
                    .frame(maxWidth: 340)
                    .overlay(
                        Text("Infos, Wetten, und vieles mehr... Viel Spaß!")
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                Color.black)
                            .cornerRadius(10)
                            .shadow(
                                color: .white, radius: 10,
                                x: 1, y: 10)
                            )
                // Text horizontal von Recjhts nach Links
                    .offset(x: textOffset)
                    .onAppear {
                        withAnimation(.linear(duration: 5)) {
                            textOffset = 0
                        }
                    }
            }
        }
    }
    
    struct AnimatedScrollingText: View {
        @State private var textOffset: CGFloat = UIScreen.main.bounds.width // Startpunkt außerhalb
        private let scrollingText: String
        
        init(text: String) {
            self.scrollingText = text
        }
        
        var body: some View {
            ZStack {
                Text(scrollingText)
                    .font(.title3)
                    .lineLimit(2)
                    .foregroundColor(.white)
                    .offset(x: textOffset) // Dynamische Position
                    .onAppear {
                        startTextAnimation()
                    }
            }
        }
        
        private func startTextAnimation() {
            let totalWidth = UIScreen.main.bounds.width
            textOffset = totalWidth // Startpunkt rechts
            
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                textOffset -= 2 // Nach links
                
                if textOffset <= 0 {
                    timer.invalidate()
                    textOffset = 0
                }
            }
        }
    }
    
    struct SectionView: View {
        let sectionName: String
        @Binding var expandedSection: String?
        
        var body: some View {
            DisclosureGroup(isExpanded: Binding(
                get: { expandedSection == sectionName },
                set: { expandedSection = $0 ? sectionName : nil }
            )) {
                ScrollView {
                    switch sectionName {
                    case "Events":
                        Text("Tauche ein in die Welt des Sports! Hier findest du eine riesige Auswahl an Events aus den verschiedensten Sportarten...")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    case "Details":
                        Text("Hier erfährst du alles, was du wissen musst...")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    case "Wetten":
                        Text("Zeig dein Können als Sport-Analyst...")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    case "Statistiken":
                        Text("Behalte den Überblick...")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    default:
                        Text("Inhalt für \(sectionName)")
                    }
                }
                .frame(height: 48)
                Spacer()
            } label: {
                Text(sectionName)
                    .font(.headline)
                    .foregroundColor(.orange)
                    .padding()
            }
            .background(.white.opacity(0.4))
            .cornerRadius(8)
            .padding(.horizontal, 32)
            .padding(.vertical, 4)
            .animation(.easeInOut, value: expandedSection)
            
        }
    }
}

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
            }
        }
    }
    
    private func startTimerBanner(geometry: GeometryProxy) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            DispatchQueue.main.async {
                offset -= 1
            }
        }
    }
}

// Banner
struct StyledBannerImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 80)
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
