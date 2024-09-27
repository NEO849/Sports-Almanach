//
//  Season.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

/// Jahreszahlenbereiche (Saison)
enum Season: String, Identifiable, CaseIterable {
    case season201872018 = "2017-2018"
    case season2018_2019 = "2018-2019"
    case season2019_2020 = "2019-2020"

    
    var id: String { rawValue }
    
    var year: String {
        rawValue // Direkten Wert zurückgeben
    }
}
