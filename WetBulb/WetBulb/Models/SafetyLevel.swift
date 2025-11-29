//
//  SafetyLevel.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import SwiftUI

/// Represents heat safety levels based on wet bulb temperature
enum SafetyLevel: String, Codable, CaseIterable {
    case safe
    case caution
    case warning
    case danger
    case extreme

    /// Human-readable label for the safety level
    var label: String {
        switch self {
        case .safe:
            return "Safe"
        case .caution:
            return "Caution"
        case .warning:
            return "Warning"
        case .danger:
            return "Danger"
        case .extreme:
            return "Extreme Danger"
        }
    }

    /// Primary color for this safety level
    var color: Color {
        switch self {
        case .safe:
            return .green
        case .caution:
            return .yellow
        case .warning:
            return .orange
        case .danger:
            return .red
        case .extreme:
            return Color(red: 0.6, green: 0.1, blue: 0.1) // Dark red
        }
    }

    /// Gradient colors for background display
    var gradientColors: [Color] {
        switch self {
        case .safe:
            return [Color(red: 0.063, green: 0.725, blue: 0.506), Color(red: 0.02, green: 0.588, blue: 0.412)]
        case .caution:
            return [Color(red: 0.961, green: 0.620, blue: 0.043), Color(red: 0.851, green: 0.467, blue: 0.024)]
        case .warning:
            return [Color(red: 0.976, green: 0.451, blue: 0.086), Color(red: 0.918, green: 0.345, blue: 0.047)]
        case .danger:
            return [Color(red: 0.937, green: 0.267, blue: 0.267), Color(red: 0.863, green: 0.149, blue: 0.149)]
        case .extreme:
            return [Color(red: 0.6, green: 0.106, blue: 0.106), Color(red: 0.498, green: 0.114, blue: 0.114)]
        }
    }

    /// Wet bulb temperature thresholds in Celsius for this level
    /// Returns the minimum temperature for this level
    var thresholdMinimum: Double {
        switch self {
        case .safe:
            return -Double.infinity
        case .caution:
            return 21.0
        case .warning:
            return 26.0
        case .danger:
            return 30.0
        case .extreme:
            return 32.0
        }
    }

    /// Determines safety level from wet bulb temperature and activity level
    /// - Parameters:
    ///   - wetBulbTemp: Wet bulb temperature in Celsius
    ///   - activity: Current activity level
    /// - Returns: Appropriate safety level
    static func from(wetBulbTemp: Double, activity: ActivityLevel) -> SafetyLevel {
        // Apply activity adjustment to the wet bulb temperature
        let adjustedWBT = wetBulbTemp - activity.thresholdAdjustment

        if adjustedWBT >= 32.0 {
            return .extreme
        } else if adjustedWBT >= 30.0 {
            return .danger
        } else if adjustedWBT >= 26.0 {
            return .warning
        } else if adjustedWBT >= 21.0 {
            return .caution
        } else {
            return .safe
        }
    }

    /// Get recommendations for this safety level and activity combination
    /// - Parameter activity: The activity level
    /// - Returns: Array of recommendation strings
    func recommendations(for activity: ActivityLevel) -> [String] {
        let recommendationsMap: [SafetyLevel: [ActivityLevel: [String]]] = [
            .safe: [
                .rest: [
                    "Conditions are safe for normal activities",
                    "No special precautions needed",
                    "Stay hydrated as always"
                ],
                .light: [
                    "Safe for light outdoor activities",
                    "Normal hydration sufficient",
                    "Enjoy your activities"
                ],
                .moderate: [
                    "Safe for moderate exercise",
                    "Stay hydrated during activity",
                    "Take normal breaks"
                ],
                .intense: [
                    "Safe for intense exercise",
                    "Maintain good hydration",
                    "Monitor how you feel"
                ]
            ],
            .caution: [
                .rest: [
                    "Generally safe but monitor your comfort",
                    "Stay hydrated throughout the day",
                    "Reduce prolonged intense outdoor exertion"
                ],
                .light: [
                    "Light activities are manageable",
                    "Increase water intake",
                    "Take breaks in shade or AC"
                ],
                .moderate: [
                    "Reduce intensity of outdoor activities",
                    "Frequent hydration is important",
                    "Take regular breaks in cool areas"
                ],
                .intense: [
                    "Consider postponing intense outdoor exercise",
                    "If exercising, reduce intensity significantly",
                    "Hydrate before, during, and after activity"
                ]
            ],
            .warning: [
                .rest: [
                    "Limit time outdoors",
                    "Stay in air-conditioned areas when possible",
                    "Drink water regularly even if not thirsty",
                    "Check on vulnerable individuals"
                ],
                .light: [
                    "Limit outdoor activities to essential only",
                    "Take frequent breaks indoors",
                    "Increase fluid intake significantly",
                    "Watch for signs of heat stress"
                ],
                .moderate: [
                    "Avoid outdoor physical activities",
                    "If activity necessary, take very frequent breaks",
                    "Heavy hydration required",
                    "Watch for heat exhaustion symptoms"
                ],
                .intense: [
                    "Do not perform intense physical activity",
                    "Postpone exercise to cooler conditions",
                    "Serious heat illness risk",
                    "Stay indoors in air conditioning"
                ]
            ],
            .danger: [
                .rest: [
                    "Dangerous conditions - minimize outdoor exposure",
                    "Stay in air conditioning if possible",
                    "Drink fluids continuously",
                    "Never leave anyone in vehicles",
                    "Seek immediate help if feeling unwell"
                ],
                .light: [
                    "Do not perform outdoor activities",
                    "Stay indoors with air conditioning",
                    "High risk of heat-related illness",
                    "Check on others frequently"
                ],
                .moderate: [
                    "Extremely dangerous for any outdoor activity",
                    "Heat stroke risk is very high",
                    "Remain in air-conditioned spaces",
                    "Seek medical help if symptoms appear"
                ],
                .intense: [
                    "Life-threatening conditions for physical exertion",
                    "Do not exercise under any circumstances",
                    "Remain in climate-controlled environment",
                    "Emergency services on alert"
                ]
            ],
            .extreme: [
                .rest: [
                    "EXTREME DANGER - Life-threatening conditions",
                    "Minimize all outdoor exposure",
                    "Ensure continuous air conditioning access",
                    "Check on vulnerable people immediately",
                    "Call emergency services if any symptoms"
                ],
                .light: [
                    "EXTREME DANGER - Do not go outside",
                    "Life-threatening heat conditions",
                    "Stay in air-conditioned shelter",
                    "This is an emergency situation"
                ],
                .moderate: [
                    "EXTREME DANGER - Do not go outside",
                    "Any activity carries severe risk",
                    "Heat stroke likely without proper shelter",
                    "Follow emergency protocols"
                ],
                .intense: [
                    "EXTREME DANGER - Do not go outside",
                    "Physical activity is potentially fatal",
                    "Treat this as a heat emergency",
                    "Seek cooling shelter immediately"
                ]
            ]
        ]

        return recommendationsMap[self]?[activity] ?? []
    }
}
