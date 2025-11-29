//
//  WeatherViewModel.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation
import CoreLocation
import Observation

/// Main view model that manages weather data, location, and app state
@Observable
@MainActor
class WeatherViewModel {

    // MARK: - Published State

    /// Current weather data
    private(set) var weatherData: WeatherData?

    /// Whether data is currently being loaded
    private(set) var isLoading = false

    /// Error message to display to user
    private(set) var errorMessage: String?

    /// Currently selected activity level
    var selectedActivity: ActivityLevel

    // MARK: - Services

    private let weatherService = WeatherService()
    private let locationService = LocationService()
    private let settings = AppSettings.shared

    // MARK: - Initialization

    init() {
        self.selectedActivity = settings.defaultActivity
    }

    // MARK: - Computed Properties

    /// Current safety level based on weather data and selected activity
    var currentSafetyLevel: SafetyLevel? {
        guard let data = weatherData else { return nil }
        return data.safetyLevel(for: selectedActivity)
    }

    /// Safety recommendations for current conditions
    var recommendations: [String] {
        guard let level = currentSafetyLevel else { return [] }
        return level.recommendations(for: selectedActivity)
    }

    /// Wet bulb temperature in user's preferred unit
    var displayWetBulbTemp: Double? {
        guard let data = weatherData else { return nil }
        return settings.temperature(data.wetBulbTemperature)
    }

    /// Dry bulb temperature in user's preferred unit
    var displayDryTemp: Double? {
        guard let data = weatherData else { return nil }
        return settings.temperature(data.temperature)
    }

    /// Temperature unit string
    var temperatureUnit: String {
        settings.temperatureUnit
    }

    /// Whether we have fresh data
    var hasFreshData: Bool {
        weatherData?.isFresh ?? false
    }

    /// Time since last update
    var lastUpdateText: String {
        guard let data = weatherData else { return "Never" }
        let interval = Date().timeIntervalSince(data.timestamp)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            let hours = Int(interval / 3600)
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }
    }

    // MARK: - Public Methods

    /// Load weather data for current location
    func loadWeather() async {
        isLoading = true
        errorMessage = nil

        do {
            // First, try to get location
            let location: CLLocation

            do {
                location = try await locationService.requestLocation()
            } catch {
                // If location fails, try to use cached location
                if let lat = settings.lastKnownLatitude,
                   let lon = settings.lastKnownLongitude {
                    location = CLLocation(latitude: lat, longitude: lon)
                    errorMessage = "Using last known location"
                } else {
                    throw error
                }
            }

            // Save location for future use
            settings.lastKnownLatitude = location.coordinate.latitude
            settings.lastKnownLongitude = location.coordinate.longitude

            // Fetch weather data
            let data = try await weatherService.fetchWeather(for: location.coordinate)

            // Update state
            weatherData = data
            settings.cachedWeatherData = data
            isLoading = false

        } catch {
            isLoading = false

            // Try to use cached data if available
            if let cached = settings.cachedWeatherData {
                weatherData = cached
                errorMessage = "Using cached data: \(error.localizedDescription)"
            } else {
                errorMessage = error.localizedDescription
                weatherData = nil
            }
        }
    }

    /// Refresh weather data
    func refresh() async {
        await loadWeather()
    }

    /// Clear error message
    func clearError() {
        errorMessage = nil
    }
}
