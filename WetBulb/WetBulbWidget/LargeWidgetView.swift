//
//  LargeWidgetView.swift
//  WetBulbWidget
//
//  Created by Claude on 11/29/25.
//

import SwiftUI
import WidgetKit

/// Large widget view - full information with recommendations
struct LargeWidgetView: View {
    let entry: WetBulbWidgetEntry

    var body: some View {
        if let wetBulbTemp = entry.displayWetBulbTemp,
           let dryTemp = entry.displayDryTemp,
           let safetyLevel = entry.safetyLevel,
           let weatherData = entry.weatherData {

            VStack(spacing: 12) {
                // Main WBT display
                VStack(spacing: 6) {
                    HStack(alignment: .top, spacing: 3) {
                        Text(String(format: "%.1f", wetBulbTemp))
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                        Text(entry.temperatureUnit)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .opacity(0.9)
                            .padding(.top, 6)
                    }
                    .foregroundColor(.white)

                    Text(safetyLevel.label.uppercased())
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(1)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        colors: safetyLevel.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)

                // Conditions grid
                HStack(spacing: 12) {
                    // Temperature
                    VStack(spacing: 4) {
                        Text("TEMPERATURE")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.1f", dryTemp))
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                            Text(entry.temperatureUnit)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.systemGray6)
                    .cornerRadius(8)

                    // Humidity
                    VStack(spacing: 4) {
                        Text("HUMIDITY")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.0f", weatherData.humidity))
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                            Text("%")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.systemGray6)
                    .cornerRadius(8)
                }

                // Top recommendations (first 3)
                VStack(alignment: .leading, spacing: 6) {
                    Text("SAFETY TIPS")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(0.5)

                    ForEach(Array(entry.recommendations.prefix(3).enumerated()), id: \.offset) { _, recommendation in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(safetyLevel.color)

                            Text(recommendation)
                                .font(.system(size: 11))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.systemGray6)
                .cornerRadius(8)
            }
            .padding(12)

        } else {
            // Placeholder
            VStack(spacing: 12) {
                Image(systemName: "thermometer.medium")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)

                Text("No weather data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Open the app to load data")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview(as: .systemLarge) {
    WetBulbWidget()
} timeline: {
    WetBulbWidgetEntry.example
}
