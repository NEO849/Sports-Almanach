//
//  Sports.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 30.10.24.
//

import Foundation

public enum Sport: String, Identifiable, CaseIterable, CustomStringConvertible {
    case soccer = "Soccer"
    case tennis = "Tennis"
    case golf = "Golf"
    case football = "Football"
    case iceHockey = "Ice Hockey"
    case basketball = "Basketball"
    
    public var id: String { rawValue }
    
    // CustomStringConvertible Konformität
    public var description: String { rawValue }
    
    public static var defaultSport: Sport { return .soccer }
}
