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
    @State private var textOffset: CGFloat = 0
    @State private var expandedSection: String?
    
    struct BannerImage: Identifiable, Hashable {
        let id = UUID()
        let imageName: String
    }
    
    // Array
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
                                  .padding(.top, 12)
                          }
                          .padding(.trailing, 32)
                      }
                      .padding()
                      
                      ZStack {
                          Image("appname")
                              .resizable()
                              .scaledToFit()
                              .scaleEffect(7.5)
                              .padding(.horizontal, 32)
                              .padding(.top, 72)
                      }
                                            
                      ZStack {
                          Text("Willkommen im Sports-Almanach! Du finest huier Evengs, Ergebnisse, Spiel, Spass und Spannung durch Spielgeld-Wetten. Battle dich mit deinen Freunden und schaut wer der Sportprofi unter euch ist...")
                              .font(.title3)
                              .lineLimit(2)
                              .foregroundColor(.white)
                              .offset(x: textOffset)
                              .onAppear {
                                  Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                                      textOffset -= 2
                                      if textOffset < -UIScreen.main.bounds.width {
                                          textOffset = UIScreen.main.bounds.width
                                      }
                                  }
                              }
                      }
                      .padding(.bottom, 24)
                      
                      Rectangle()
                          .frame(height: 1)
                          .foregroundColor(.orange)
                          .padding(.bottom, 24)
                      
                      VStack(spacing: 20) {
                          SectionView(sectionName: "Events", expandedSection: $expandedSection)
                          SectionView(sectionName: "Details", expandedSection: $expandedSection)
                          SectionView(sectionName: "Wetten", expandedSection: $expandedSection)
                          SectionView(sectionName: "Statistiken", expandedSection: $expandedSection)
                      }
                      .padding(.horizontal, 32)
                      .padding(.vertical, 4)
                      
                      Rectangle()
                          .frame(height: 1)
                          .foregroundColor(.orange)
                          .padding(.bottom, 24)
                      
                      AutoScrollingBannerView(bannerImages: bannerImages)
                          .padding(.bottom, 60)
                  }
                  .navigationBarBackButtonHidden(true)
                  .onChange(of: userViewModel.isLoggedIn) { isLoggedIn in
                      if !isLoggedIn {
                          navigateToLogin = true
                      }
                  }
                  .navigationDestination(isPresented: $navigateToLogin) {
                      LoginView()
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
                  .frame(height: 80)
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
                        StyledImageView(imageName: image.imageName)
                            .frame(width: 100, height: 80)
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width * CGFloat(repeatedBannerImages.count), alignment: .leading)
                .offset(x: offset)
                .onAppear {
                    startTimer(geometry: geometry)
                }
            }
        }
    }
    
    private func startTimer(geometry: GeometryProxy) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            DispatchQueue.main.async {
                offset -= 1
                
                // Zurücksetzen des Offsets am Ende der Bilder
                if offset <= -geometry.size.width * CGFloat(repeatedBannerImages.count - bannerImages.count) {
                    offset = 0
                }
            }
        }
    }
}

// BannerBild-Ansicht
struct StyledImageView: View {
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
