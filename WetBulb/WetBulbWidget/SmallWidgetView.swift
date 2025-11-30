//
//  SmallWidgetView.swift
//  WetBulbWidget
//
//  Created by Claude on 11/29/25.
//

import SwiftUI
import WidgetKit

/// Small widget view - just wet bulb temperature and color
struct SmallWidgetView: View {
    let entry: WetBulbWidgetEntry

    var body: some View {
        if let wetBulbTemp = entry.displayWetBulbTemp,
           let safetyLevel = entry.safetyLevel {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: safetyLevel.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Temperature display
                VStack(spacing: 4) {
                    HStack(alignment: .top, spacing: 2) {
                        Text(String(format: "%.0f", wetBulbTemp))
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                        Text(entry.temperatureUnit)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .opacity(0.9)
                            .padding(.top, 2)
                    }
                    .foregroundColor(.white)

                    Text("WET BULB")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(1)
                }
            }
        } else {
            // Placeholder
            ZStack {
                Color.gray.opacity(0.3)

                VStack(spacing: 8) {
                    Image(systemName: "thermometer.medium")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)

                    Text("No Data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview(as: .systemSmall) {
    WetBulbWidget()
} timeline: {
    WetBulbWidgetEntry.example
}
