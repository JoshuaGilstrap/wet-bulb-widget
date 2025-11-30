//
//  WetBulbWidgetEntry.swift
//  WetBulbWidget
//
//  Created by Claude on 11/29/25.
//

import WidgetKit
import Foundation

/// Timeline entry for the widget
struct WetBulbWidgetEntry: TimelineEntry {
    let date: Date
    let weatherData: WeatherData?
    let useFahrenheit: Bool
    let defaultActivity: ActivityLevel

    /// Wet bulb temperature in user's preferred unit
    var displayWetBulbTemp: Double? {
        guard let data = weatherData else { return nil }
        let wetBulb = data.wetBulbTemperature
        return useFahrenheit ? WetBulbCalculator.celsiusToFahrenheit(wetBulb) : wetBulb
    }

    /// Dry bulb temperature in user's preferred unit
    var displayDryTemp: Double? {
        guard let data = weatherData else { return nil }
        return useFahrenheit ? WetBulbCalculator.celsiusToFahrenheit(data.temperature) : data.temperature
    }

    /// Temperature unit string
    var temperatureUnit: String {
        useFahrenheit ? "°F" : "°C"
    }

    /// Current safety level
    var safetyLevel: SafetyLevel? {
        guard let data = weatherData else { return nil }
        return data.safetyLevel(for: defaultActivity)
    }

    /// Safety recommendations
    var recommendations: [String] {
        guard let level = safetyLevel else { return [] }
        return level.recommendations(for: defaultActivity)
    }

    // MARK: - Example Data

    /// Placeholder entry for loading state
    static var placeholder: WetBulbWidgetEntry {
        WetBulbWidgetEntry(
            date: Date(),
            weatherData: nil,
            useFahrenheit: true,
            defaultActivity: .rest
        )
    }

    /// Example entry for previews
    static var example: WetBulbWidgetEntry {
        let exampleData = WeatherData(
            temperature: 28.0, // 82.4°F
            humidity: 65.0,
            location: LocationInfo(latitude: 37.7749, longitude: -122.4194, name: "San Francisco"),
            timestamp: Date()
        )

        return WetBulbWidgetEntry(
            date: Date(),
            weatherData: exampleData,
            useFahrenheit: true,
            defaultActivity: .rest
        )
    }
}
