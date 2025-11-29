//
//  UserDefaults+Settings.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation
import SwiftUI

/// Keys for UserDefaults storage
extension UserDefaults {
    enum Keys {
        static let temperatureUnit = "temperatureUnit"
        static let defaultActivity = "defaultActivity"
        static let lastKnownLatitude = "lastKnownLatitude"
        static let lastKnownLongitude = "lastKnownLongitude"
        static let cachedWeatherData = "cachedWeatherData"
    }
}

/// App settings using UserDefaults with SwiftUI property wrappers
@Observable
class AppSettings {

    /// Shared instance for app-wide access
    static let shared = AppSettings()

    /// Use Fahrenheit for temperature display (default: true)
    var useFahrenheit: Bool {
        get {
            UserDefaults.standard.object(forKey: UserDefaults.Keys.temperatureUnit) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.temperatureUnit)
        }
    }

    /// Default activity level
    var defaultActivity: ActivityLevel {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Keys.defaultActivity),
               let activity = ActivityLevel(rawValue: rawValue) {
                return activity
            }
            return .rest
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaults.Keys.defaultActivity)
        }
    }

    /// Last known latitude for caching
    var lastKnownLatitude: Double? {
        get {
            let value = UserDefaults.standard.double(forKey: UserDefaults.Keys.lastKnownLatitude)
            return value != 0 ? value : nil
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UserDefaults.Keys.lastKnownLatitude)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.lastKnownLatitude)
            }
        }
    }

    /// Last known longitude for caching
    var lastKnownLongitude: Double? {
        get {
            let value = UserDefaults.standard.double(forKey: UserDefaults.Keys.lastKnownLongitude)
            return value != 0 ? value : nil
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UserDefaults.Keys.lastKnownLongitude)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.lastKnownLongitude)
            }
        }
    }

    /// Cached weather data
    var cachedWeatherData: WeatherData? {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.Keys.cachedWeatherData) else {
                return nil
            }
            return try? JSONDecoder().decode(WeatherData.self, from: data)
        }
        set {
            if let data = newValue,
               let encoded = try? JSONEncoder().encode(data) {
                UserDefaults.standard.set(encoded, forKey: UserDefaults.Keys.cachedWeatherData)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.cachedWeatherData)
            }
        }
    }

    /// Temperature unit string for display
    var temperatureUnit: String {
        useFahrenheit ? "°F" : "°C"
    }

    /// Convert temperature based on current unit preference
    func temperature(_ celsius: Double) -> Double {
        useFahrenheit ? WetBulbCalculator.celsiusToFahrenheit(celsius) : celsius
    }

    private init() {}
}
