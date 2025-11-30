//
//  WetBulbWidgetProvider.swift
//  WetBulbWidget
//
//  Created by Claude on 11/29/25.
//

import WidgetKit
import SwiftUI

/// Timeline provider for the widget
struct WetBulbWidgetProvider: TimelineProvider {

    /// Placeholder entry shown while widget is loading
    func placeholder(in context: Context) -> WetBulbWidgetEntry {
        WetBulbWidgetEntry.placeholder
    }

    /// Snapshot for widget gallery
    func getSnapshot(in context: Context, completion: @escaping (WetBulbWidgetEntry) -> Void) {
        // In preview context, show example data immediately
        if context.isPreview {
            completion(WetBulbWidgetEntry.example)
            return
        }

        // Try to load cached data for snapshot
        Task {
            if let entry = await loadCurrentEntry() {
                completion(entry)
            } else {
                completion(WetBulbWidgetEntry.placeholder)
            }
        }
    }

    /// Timeline for widget updates
    func getTimeline(in context: Context, completion: @escaping (Timeline<WetBulbWidgetEntry>) -> Void) {
        Task {
            // Try to fetch fresh data
            if let entry = await fetchWeatherAndCreateEntry() {
                // Schedule next update in 15 minutes
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } else {
                // If fetch failed, use cached data and retry in 5 minutes
                if let cachedEntry = await loadCurrentEntry() {
                    let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
                    let timeline = Timeline(entries: [cachedEntry], policy: .after(nextUpdate))
                    completion(timeline)
                } else {
                    // No data available, show placeholder and retry in 1 minute
                    let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let timeline = Timeline(entries: [WetBulbWidgetEntry.placeholder], policy: .after(nextUpdate))
                    completion(timeline)
                }
            }
        }
    }

    // MARK: - Data Fetching

    /// Fetch fresh weather data and create entry
    private func fetchWeatherAndCreateEntry() async -> WetBulbWidgetEntry? {
        let settings = AppSettings.shared
        let weatherService = WeatherService()

        // Get last known location
        guard let latitude = settings.lastKnownLatitude,
              let longitude = settings.lastKnownLongitude else {
            return nil
        }

        do {
            // Fetch weather data
            let weatherData = try await weatherService.fetchWeather(latitude: latitude, longitude: longitude)

            // Cache for future use
            settings.cachedWeatherData = weatherData

            // Create entry
            return WetBulbWidgetEntry(
                date: Date(),
                weatherData: weatherData,
                useFahrenheit: settings.useFahrenheit,
                defaultActivity: settings.defaultActivity
            )
        } catch {
            print("Widget failed to fetch weather: \(error)")
            return nil
        }
    }

    /// Load entry from cached data
    private func loadCurrentEntry() async -> WetBulbWidgetEntry? {
        let settings = AppSettings.shared

        guard let weatherData = settings.cachedWeatherData else {
            return nil
        }

        return WetBulbWidgetEntry(
            date: Date(),
            weatherData: weatherData,
            useFahrenheit: settings.useFahrenheit,
            defaultActivity: settings.defaultActivity
        )
    }
}
