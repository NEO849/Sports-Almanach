//
//  Season.swift
//  Sports-Almanach
//
//  Compact season list. We default to the most-recent completed season so the
//  app immediately has results to render (legacy default was 2020-2021).
//

import Foundation

public enum Season: String, Identifiable, CaseIterable, CustomStringConvertible, Codable, Sendable {
    case season20202021 = "2020-2021"
    case season20212022 = "2021-2022"
    case season20222023 = "2022-2023"
    case season20232024 = "2023-2024"
    case season20242025 = "2024-2025"

    public var id: String { rawValue }
    public var description: String { rawValue }

    public static var `default`: Season { .season20232024 }

    /// Compatibility alias retained for older call sites still importing the enum.
    public static var defaultSeason: Season { .default }
}
