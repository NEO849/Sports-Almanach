//
//  Banner.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 05.02.25.
//

import Foundation

// MARK: - Banner Model
// Zentrale Verwaltung aller Banner-Bilder
struct Banner: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    
    // MARK: - Statische Banner-Daten
    static let defaultBanners: [Banner] = [
        Banner(imageName: "bannersports"),
        Banner(imageName: "boxen"),
        Banner(imageName: "golf"),
        Banner(imageName: "laufen"),
        Banner(imageName: "radfahren"),
        Banner(imageName: "schwimmen"),
        Banner(imageName: "tennis")
    ]
}

// MARK: - Banner Kategorien
extension Banner {
    // Definiert die verschiedenen Anzeige-Kategorien für Banner
    enum Category: String {
        case featured    // Für die Hauptansicht/Highlights
        case sports     // Für Sport-spezifische Banner
    }
    
    // Filtert Banner nach Kategorie
    static func banners(for category: Category) -> [Banner] {
        switch category {
        case .featured:
            // Zeigt alle Banner in der Featured-Sektion
            return defaultBanners
        case .sports:
            // Filtert nur Sport-spezifische Banner
            return defaultBanners.filter {
                ["boxen", "golf", "tennis"].contains($0.imageName)
            }
        }
    }
}
