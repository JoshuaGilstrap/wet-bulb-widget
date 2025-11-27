# Swift/iOS Migration Guide

This document outlines the path from the web proof of concept to native iOS/macOS applications with WidgetKit support.

## Overview

The web PoC validates the core concept. Converting to Swift will provide:
- Native widgets on iOS Lock Screen, Home Screen, and StandBy
- Mac menu bar widget
- watchOS complications
- Background updates without user interaction
- Better performance and battery efficiency
- App Store distribution

## Technology Stack

### Core Technologies
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Widgets**: WidgetKit
- **Networking**: URLSession with async/await
- **Concurrency**: Swift Structured Concurrency
- **Storage**: UserDefaults (settings), Core Data (optional for history)
- **Location**: CoreLocation

### Minimum Requirements
- **iOS**: 17.0+ (for latest widget features)
- **macOS**: 14.0+ (Sonoma)
- **watchOS**: 10.0+
- **Xcode**: 15.0+

## Project Structure

```
WetBulbWidget/
├── WetBulbWidget.xcodeproj
├── WetBulbApp/                          # Main app target
│   ├── WetBulbApp.swift                 # App entry point
│   ├── Views/
│   │   ├── ContentView.swift            # Main view
│   │   ├── DetailView.swift             # Detailed conditions
│   │   ├── SettingsView.swift           # Settings and preferences
│   │   └── EducationView.swift          # About wet bulb temperature
│   ├── ViewModels/
│   │   └── WeatherViewModel.swift       # MVVM pattern
│   └── Assets.xcassets
│
├── WetBulbWidget/                       # Widget extension target
│   ├── WetBulbWidget.swift              # Widget definition
│   ├── WetBulbWidgetBundle.swift        # Widget bundle
│   ├── Provider.swift                   # Timeline provider
│   └── Views/
│       ├── SmallWidgetView.swift        # Small widget UI
│       ├── MediumWidgetView.swift       # Medium widget UI
│       └── LargeWidgetView.swift        # Large widget UI
│
├── Shared/                              # Shared between app and widget
│   ├── Models/
│   │   ├── WeatherData.swift            # Data models
│   │   ├── SafetyLevel.swift            # Safety level enum
│   │   └── ActivityLevel.swift          # Activity level enum
│   ├── Services/
│   │   ├── WeatherService.swift         # API networking
│   │   ├── LocationService.swift        # CoreLocation wrapper
│   │   └── WetBulbCalculator.swift      # Core calculation logic
│   ├── Utilities/
│   │   ├── UserPreferences.swift        # UserDefaults wrapper
│   │   └── ColorScheme.swift            # Safety level colors
│   └── Extensions/
│       ├── Color+Safety.swift           # Color extensions
│       └── Double+Temperature.swift     # Temperature conversions
│
└── WetBulbWidgetWatch/                  # watchOS target (optional)
    └── Complications/
```

## Key Components to Convert

### 1. Wet Bulb Calculator

**JavaScript → Swift**

```swift
// Shared/Services/WetBulbCalculator.swift
import Foundation

struct WetBulbCalculator {
    /// Calculate wet bulb temperature using Stull (2011) formula
    /// - Parameters:
    ///   - tempCelsius: Dry bulb temperature in Celsius
    ///   - relativeHumidity: Relative humidity as percentage (0-100)
    /// - Returns: Wet bulb temperature in Celsius
    static func calculate(tempCelsius: Double, relativeHumidity: Double) -> Double {
        let T = tempCelsius
        let RH = relativeHumidity

        // Stull (2011) formula - valid for -20°C to 50°C, 5% to 99% RH
        let term1 = T * atan(0.151977 * sqrt(RH + 8.313659))
        let term2 = atan(T + RH)
        let term3 = atan(RH - 1.676331)
        let term4 = 0.00391838 * pow(RH, 1.5) * atan(0.023101 * RH)
        let constant = 4.686035

        let wetBulbTemp = term1 + term2 - term3 + term4 - constant

        return wetBulbTemp
    }
}
```

### 2. Safety Level System

```swift
// Shared/Models/SafetyLevel.swift
import SwiftUI

enum SafetyLevel: String, CaseIterable {
    case safe = "Safe"
    case caution = "Caution"
    case warning = "Warning"
    case danger = "Danger"
    case extreme = "Extreme Danger"

    /// Get safety level from wet bulb temperature and activity
    static func from(wetBulbCelsius: Double, activity: ActivityLevel) -> SafetyLevel {
        let adjustment = activity.thresholdAdjustment
        let adjustedWBT = wetBulbCelsius - adjustment

        switch adjustedWBT {
        case ..<21:
            return .safe
        case 21..<26:
            return .caution
        case 26..<30:
            return .warning
        case 30..<32:
            return .danger
        default:
            return .extreme
        }
    }

    var color: Color {
        switch self {
        case .safe:
            return Color.green
        case .caution:
            return Color.yellow
        case .warning:
            return Color.orange
        case .danger:
            return Color.red
        case .extreme:
            return Color(red: 0.6, green: 0.11, blue: 0.11)
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .safe:
            return LinearGradient(colors: [Color(hex: "10b981"), Color(hex: "059669")],
                                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .caution:
            return LinearGradient(colors: [Color(hex: "f59e0b"), Color(hex: "d97706")],
                                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .warning:
            return LinearGradient(colors: [Color(hex: "f97316"), Color(hex: "ea580c")],
                                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .danger:
            return LinearGradient(colors: [Color(hex: "ef4444"), Color(hex: "dc2626")],
                                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .extreme:
            return LinearGradient(colors: [Color(hex: "991b1b"), Color(hex: "7f1d1d")],
                                startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    func recommendations(for activity: ActivityLevel) -> [String] {
        // Return activity-specific recommendations
        // Convert JavaScript recommendations to Swift arrays
        return SafetyRecommendations.get(level: self, activity: activity)
    }
}

enum ActivityLevel: String, CaseIterable, Codable {
    case rest = "Rest / Indoor"
    case light = "Light Activity"
    case moderate = "Moderate Activity"
    case intense = "Intense Exertion"

    var thresholdAdjustment: Double {
        switch self {
        case .rest: return 0
        case .light: return -2
        case .moderate: return -4
        case .intense: return -6
        }
    }
}
```

### 3. Weather Service

```swift
// Shared/Services/WeatherService.swift
import Foundation
import CoreLocation

struct WeatherData: Codable {
    let temperature: Double
    let humidity: Double
    let timestamp: Date

    var wetBulbTemp: Double {
        WetBulbCalculator.calculate(tempCelsius: temperature, relativeHumidity: humidity)
    }
}

actor WeatherService {
    private let baseURL = "https://api.open-meteo.com/v1/forecast"

    func fetchWeather(for location: CLLocationCoordinate2D) async throws -> WeatherData {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.latitude)),
            URLQueryItem(name: "longitude", value: String(location.longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m"),
            URLQueryItem(name: "temperature_unit", value: "celsius")
        ]

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.networkError
        }

        let apiResponse = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)

        return WeatherData(
            temperature: apiResponse.current.temperature_2m,
            humidity: apiResponse.current.relative_humidity_2m,
            timestamp: Date()
        )
    }
}

enum WeatherError: Error {
    case invalidURL
    case networkError
    case decodingError
    case locationUnavailable
}

// API Response models
private struct OpenMeteoResponse: Codable {
    let current: CurrentWeather
}

private struct CurrentWeather: Codable {
    let temperature_2m: Double
    let relative_humidity_2m: Double
}
```

### 4. Widget Implementation

```swift
// WetBulbWidget/WetBulbWidget.swift
import WidgetKit
import SwiftUI

struct WetBulbWidget: Widget {
    let kind: String = "WetBulbWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WetBulbWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Wet Bulb Temperature")
        .description("Monitor heat safety conditions at a glance")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled() // iOS 17+
    }
}

struct WetBulbEntry: TimelineEntry {
    let date: Date
    let weatherData: WeatherData?
    let safetyLevel: SafetyLevel
    let activityLevel: ActivityLevel
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WetBulbEntry {
        WetBulbEntry(
            date: Date(),
            weatherData: nil,
            safetyLevel: .safe,
            activityLevel: .rest
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WetBulbEntry) -> Void) {
        Task {
            let entry = await fetchEntry()
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WetBulbEntry>) -> Void) {
        Task {
            let entry = await fetchEntry()

            // Update every 30 minutes
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

            completion(timeline)
        }
    }

    private func fetchEntry() async -> WetBulbEntry {
        do {
            let locationService = LocationService()
            let location = try await locationService.getCurrentLocation()

            let weatherService = WeatherService()
            let weather = try await weatherService.fetchWeather(for: location.coordinate)

            let preferences = UserPreferences.shared
            let activityLevel = preferences.defaultActivityLevel
            let safetyLevel = SafetyLevel.from(
                wetBulbCelsius: weather.wetBulbTemp,
                activity: activityLevel
            )

            return WetBulbEntry(
                date: Date(),
                weatherData: weather,
                safetyLevel: safetyLevel,
                activityLevel: activityLevel
            )
        } catch {
            // Return placeholder on error
            return WetBulbEntry(
                date: Date(),
                weatherData: nil,
                safetyLevel: .safe,
                activityLevel: .rest
            )
        }
    }
}
```

### 5. Small Widget View

```swift
// WetBulbWidget/Views/SmallWidgetView.swift
import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: WetBulbEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            // Background gradient based on safety level
            entry.safetyLevel.gradient

            VStack(spacing: 8) {
                if let weather = entry.weatherData {
                    // Wet bulb temperature
                    Text(String(format: "%.1f°", weather.wetBulbTemp))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Safety level
                    Text(entry.safetyLevel.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .textCase(.uppercase)
                } else {
                    Text("--")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)

                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
    }
}
```

## App Store Requirements

### Info.plist Additions

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to provide accurate wet bulb temperature and heat safety information for your area.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Allow background location access to keep your widget updated with current conditions.</string>
```

### App Capabilities
- Background Modes (for widget updates)
- Location Services

### Privacy Considerations
- Minimize data collection
- Don't track users
- Location used only for weather data
- No analytics without opt-in
- Clear privacy policy

## Testing Strategy

### Unit Tests
```swift
// Tests/WetBulbCalculatorTests.swift
import XCTest
@testable import WetBulbWidget

final class WetBulbCalculatorTests: XCTestCase {
    func testStullFormula() {
        // Test against known values
        let result1 = WetBulbCalculator.calculate(tempCelsius: 30, relativeHumidity: 50)
        XCTAssertEqual(result1, 21.5, accuracy: 0.5)

        let result2 = WetBulbCalculator.calculate(tempCelsius: 35, relativeHumidity: 60)
        XCTAssertEqual(result2, 27.1, accuracy: 0.5)

        let result3 = WetBulbCalculator.calculate(tempCelsius: 25, relativeHumidity: 80)
        XCTAssertEqual(result3, 22.7, accuracy: 0.5)
    }

    func testSafetyLevels() {
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: 20, activity: .rest), .safe)
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: 25, activity: .rest), .caution)
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: 28, activity: .rest), .warning)
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: 31, activity: .rest), .danger)
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: 33, activity: .rest), .extreme)
    }

    func testActivityAdjustments() {
        // Same WBT should give different levels based on activity
        let wbt = 23.0
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: wbt, activity: .rest), .caution)
        XCTAssertEqual(SafetyLevel.from(wetBulbCelsius: wbt, activity: .intense), .warning)
    }
}
```

### UI Tests
- Widget rendering in all sizes
- Configuration flow
- Location permission handling
- Error states

## Migration Checklist

- [ ] Set up Xcode project with app and widget targets
- [ ] Create shared framework for common code
- [ ] Implement WetBulbCalculator in Swift
- [ ] Convert safety level system
- [ ] Build WeatherService with async/await
- [ ] Implement LocationService
- [ ] Create UserPreferences wrapper
- [ ] Design and implement widget layouts (small, medium, large)
- [ ] Build Timeline Provider
- [ ] Create main app UI
- [ ] Implement settings screen
- [ ] Add educational content view
- [ ] Write unit tests
- [ ] Write UI tests
- [ ] Test on physical devices (iPhone, iPad, Mac)
- [ ] Handle edge cases and errors
- [ ] Optimize performance and battery usage
- [ ] Create App Store assets
- [ ] Write privacy policy
- [ ] Submit for review

## Performance Considerations

### Widget Updates
- Limit to 30-minute intervals to preserve battery
- Use background refresh intelligently
- Cache data when API unavailable

### Battery Optimization
- Minimize location requests
- Batch network calls
- Use efficient JSON parsing
- Avoid unnecessary calculations

### Memory Management
- Keep widget memory footprint small (< 30MB)
- Use value types (structs) where possible
- Properly manage async tasks

## Known Challenges

1. **Background Location**: Requires careful permission handling and justification
2. **Widget Limitations**: Limited interactivity, size constraints
3. **API Rate Limits**: Need graceful degradation
4. **Offline Mode**: Widget should show last known data
5. **Time Zones**: Handle location changes correctly

## Resources

- [WidgetKit Documentation](https://developer.apple.com/documentation/widgetkit)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Human Interface Guidelines - Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## Next Steps

1. Validate web PoC thoroughly
2. Gather user feedback on concept
3. Create Xcode project structure
4. Begin implementing core calculator in Swift
5. Build simple widget prototype
6. Iterate based on testing
