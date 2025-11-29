//
//  ActivityLevel.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation

/// Represents different levels of physical activity that affect heat safety thresholds
enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case rest = "Rest / Indoor"
    case light = "Light Activity"
    case moderate = "Moderate Activity"
    case intense = "Intense Exertion"

    var id: String { rawValue }

    /// Temperature adjustment in Celsius to apply to safety thresholds
    /// Higher activity levels lower the safe temperature threshold
    var thresholdAdjustment: Double {
        switch self {
        case .rest:
            return 0.0
        case .light:
            return -2.0
        case .moderate:
            return -4.0
        case .intense:
            return -6.0
        }
    }

    /// Short description of the activity level
    var description: String {
        switch self {
        case .rest:
            return "Resting or indoor activities"
        case .light:
            return "Walking, light outdoor work"
        case .moderate:
            return "Jogging, moderate exercise"
        case .intense:
            return "Running, intense physical exertion"
        }
    }
}
