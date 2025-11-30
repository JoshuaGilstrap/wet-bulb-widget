//
//  MediumWidgetView.swift
//  WetBulbWidget
//
//  Created by Claude on 11/29/25.
//

import SwiftUI
import WidgetKit

/// Medium widget view - wet bulb temp + conditions + safety level
struct MediumWidgetView: View {
    let entry: WetBulbWidgetEntry

    var body: some View {
        if let wetBulbTemp = entry.displayWetBulbTemp,
           let dryTemp = entry.displayDryTemp,
           let safetyLevel = entry.safetyLevel,
           let weatherData = entry.weatherData {

            HStack(spacing: 16) {
                // Left: Main WBT display
                VStack(spacing: 4) {
                    HStack(alignment: .top, spacing: 2) {
                        Text(String(format: "%.0f", wetBulbTemp))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                        Text(entry.temperatureUnit)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .opacity(0.9)
                            .padding(.top, 4)
                    }
                    .foregroundColor(.white)

                    Text(safetyLevel.label.uppercased())
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(0.5)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: safetyLevel.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)

                // Right: Conditions
                VStack(spacing: 12) {
                    // Temperature
                    VStack(spacing: 2) {
                        Text("TEMP")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.0f", dryTemp))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text(entry.temperatureUnit)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }

                    // Humidity
                    VStack(spacing: 2) {
                        Text("HUMIDITY")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.0f", weatherData.humidity))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text("%")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(12)

        } else {
            // Placeholder
            HStack {
                Image(systemName: "thermometer.medium")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)

                Text("No weather data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview(as: .systemMedium) {
    WetBulbWidget()
} timeline: {
    WetBulbWidgetEntry.example
}
