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
                            .font(.custom("Helvetica Neue Bold Italic", size: 32))
                            .foregroundColor(.white)
                            .shadow(color: .orange, radius: 2, x: 6, y: 10)
                            .shadow(color: .white, radius: 4, x: 3, y: 3)
                            .shadow(color: .orange, radius: 4, x: 0, y: 0)
                    }
                    .padding(.bottom, 54)
                    
                    ZStack {
                        AnimatedText()
                    }
                    .padding(.bottom, 24)
                    
                    Rectangle()
                        .frame(height: 1)
                        .frame(width: 340)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    
                    VStack(spacing: 10) {
                        SectionView(sectionName: "Events", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                        SectionView(sectionName: "Event-Details", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                        SectionView(sectionName: "Wetten", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                        SectionView(sectionName: "Statistiken", expandedSection: $expandedSection)
                            .frame(minHeight: 80)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    
                    Rectangle()
                        .frame(height: 1)
                        .frame(width: 340)
                        .foregroundColor(.white)
                        .padding(.bottom, 24)
                    
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
    
    ///  Struct´s
    
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
                            .shadow(color: .white, radius: 10, x: 3, y: 10)
                    )
                    // Von Rechts nach Links
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
        
        private var isExpanded: Bool {
            expandedSection == sectionName
        }
        
        // Opazität für nicht ausgewählte Sektionen
        private var sectionOpacity: Double {
            expandedSection == nil || expandedSection == sectionName ? 1.0 : 0.3
        }
        
        var body: some View {
            VStack {
                DisclosureGroup(isExpanded: Binding(
                    get: { isExpanded },
                    set: { expandedSection = $0 ? sectionName : nil }
                )) {
                    switch sectionName {
                    case "Events":
                        Text("Hier findest du eine riesige Auswahl an Events von verschiedenen Sportarten.")
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    case "Event-Details":
                        Text("Infos jeglicher Art, das Spiel als Video verfolgen und deine Lieblingsszenen anschauen.")
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    case "Wetten":
                        Text("Zeig dein Können als Sport-Analyst, teste dein Wissen und wette auf spannende Spiele.")
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    case "Statistiken":
                        Text("Behalte den Überblick Ranglisten uvm.")
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    default:
                        Text("Default")
                    }
                } label: {
                    HStack {
                        Text(sectionName)
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                        Spacer()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isExpanded ? Color.black.opacity(0.4) : Color.black.opacity(0.1))
                        .shadow(
                            color: isExpanded ? .black : .orange,
                            radius: isExpanded ? 10 : 1
                        )
                )
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .opacity(sectionOpacity)  // Dynamische Opazität für nicht ausgewählte Sektionen
                .animation(.easeInOut, value: expandedSection)
            }
        }
    }
}

struct AutoScrollingBannerView: View {
    let bannerImages: [HomeView.BannerImage]
       @State private var offset: CGFloat = 0
       @State private var timer: Timer?

       // Erstellt eine Liste, BannerBilder für Scrolleffect
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
                   // Berechnet die Gesamtbreite basierend auf der Anzahl der Bilder
                   .frame(width: geometry.size.width * CGFloat(repeatedBannerImages.count), alignment: .leading)
                   // Horizontale Verschiebung für Scrolleffect
                   .offset(x: offset)
                   .onAppear {
                       startTimer()
                   }
                   .onDisappear {
                       stopTimer()
                   }
               }
           }
       }

       private func startTimer() {
           timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
               DispatchQueue.main.async {
                   offset -= 1
               }
           }
       }

       private func stopTimer() {
           timer?.invalidate()
           timer = nil
       }
   }

struct StyledBannerImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 90, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            )
            .cornerRadius(10)
            .shadow(color: .orange, radius: 4, x: 3, y: 3)
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
