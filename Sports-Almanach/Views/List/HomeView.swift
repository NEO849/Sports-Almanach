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
    
    struct BannerImage: Identifiable {
        let id = UUID()
        let imageName: String
    }
    
    // Array der Banner-Bildern
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
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            userViewModel.logout()  // Logout
                            showLoginView = true
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.blue)
                            .padding(.top, 32)}
                        .padding(.trailing, 32)
                    }
                    .padding(.top, 24)
                    Spacer()
                }
                VStack {
                    Image("appname")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    
                    VStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.orange)
                            .padding(.bottom, 24)
                        
                        // Sektionen
                        SectionView(sectionName: "Events", expandedSection: $expandedSection)
                        SectionView(sectionName: "Details", expandedSection: $expandedSection)
                        SectionView(sectionName: "Wetten", expandedSection: $expandedSection)
                        SectionView(sectionName: "Statistiken", expandedSection: $expandedSection)
                            .padding(.bottom, 16)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.orange)
                            .padding(.bottom, 24)
                        Spacer()
                        BannerScrollView(bannerImages: bannerImages)
                            .padding(.bottom, 160)
                    }
                    .frame(maxHeight: 240)
                    
                }
                .padding(.bottom, 100)
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
    
    // Section zum ausklappen
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
                        Text("Tauche ein in die Welt des Sports! Hier findest du eine riesige Auswahl an Events aus den verschiedensten Sportarten. Egal ob Fußball, Basketball, Tennis oder American Football – hier ist für jeden etwas dabei! Wähle deine Lieblingssportart, die Liga und die Saison aus und entdecke viele spannende Spiele durch Klick auf ein Event. Damit du dein Sportwissen auf Spielerische Art Testen kannst auf die du wetten kannst. Erlebe den Nervenkitzel hautnah und fiebere mit deinen Teams mit!"
                        )
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    case "Details":
                        Text("Hier erfährst du alles, was du wissen musst! Klicke auf ein Event und erhalte detaillierte Informationen zu den Teams, Spielern, Statistiken und vielem mehr. So kannst du fundierte Entscheidungen treffen und deine Gewinnchancen erhöhen. Wissen ist Macht – nutze die Detailansicht, um zum Experten zu werden!"
                        )
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    case "Wetten":
                        Text("Zeig dein Können als Sport-Analyst! Vergleiche die Quoten, analysiere die Statistiken und platziere deine Wetten. Trau dich, auf den Außenseiter zu setzen, oder sichere dir einen kleinen Gewinn mit einer soliden Wette auf den Favoriten. Hier kannst du dein Sportwissen unter Beweis stellen und gleichzeitig tolle Gewinne abräumen!"
                        )
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    case "Statistiken":
                        Text("Behalte den Überblick! In der Statistik-Ansicht siehst du, wie sich deine Wetten entwickeln, sowie eine Rangliste der erfolgreichsten Spielern. Schau dir deine Erfolge, analysiere deine Wettscheine und lerne aus deinen Fehlern. Hier findest du alle wichtigen Informationen, um deine Wettstrategie zu optimieren und deine Gewinnchancen zu maximieren. Werde zum Meister der Sportwetten!"
                        )
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    default:
                        Text("Inhalt für \(sectionName)")
                    }
                }
                .frame(height: 100)
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

// Horizontale ScrollView für Bilder
struct BannerScrollView: View {
    let bannerImages: [HomeView.BannerImage]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(bannerImages) { image in
                    StyledImageView(imageName: image.imageName)
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
