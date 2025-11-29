//
//  WeatherData.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation
import CoreLocation

/// Location information for weather data
struct LocationInfo: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let name: String?

    init(latitude: Double, longitude: Double, name: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }

    init(coordinate: CLLocationCoordinate2D, name: String? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.name = name
    }

    /// Formatted coordinate string for display
    var coordinateString: String {
        String(format: "%.4f°, %.4f°", latitude, longitude)
    }
}

/// Complete weather data including wet bulb temperature calculation
struct WeatherData: Codable, Equatable {
    let temperature: Double      // Celsius
    let humidity: Double          // Percentage (0-100)
    let location: LocationInfo
    let timestamp: Date

    /// Calculated wet bulb temperature in Celsius
    var wetBulbTemperature: Double {
        WetBulbCalculator.calculate(temperature: temperature, humidity: humidity)
    }

    /// Convert temperature to Fahrenheit
    var temperatureFahrenheit: Double {
        temperature * 9/5 + 32
    }

    /// Convert wet bulb temperature to Fahrenheit
    var wetBulbTemperatureFahrenheit: Double {
        wetBulbTemperature * 9/5 + 32
    }

    /// Get safety level for a given activity
    func safetyLevel(for activity: ActivityLevel) -> SafetyLevel {
        SafetyLevel.from(wetBulbTemp: wetBulbTemperature, activity: activity)
    }

    /// Check if data is fresh (less than 15 minutes old)
    var isFresh: Bool {
        Date().timeIntervalSince(timestamp) < 15 * 60
    }
}
