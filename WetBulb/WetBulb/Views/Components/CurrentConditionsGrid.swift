//
//  CurrentConditionsGrid.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import SwiftUI

/// Grid displaying current temperature and humidity
struct CurrentConditionsGrid: View {
    let temperature: Double
    let humidity: Double
    let unit: String

    var body: some View {
        HStack(spacing: 16) {
            // Temperature card
            ConditionCard(
                label: "Temperature",
                value: String(format: "%.1f", temperature),
                unit: unit
            )

            // Humidity card
            ConditionCard(
                label: "Humidity",
                value: String(format: "%.0f", humidity),
                unit: "%"
            )
        }
    }
}

/// Individual condition card
struct ConditionCard: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            Text(label.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)
                .tracking(0.5)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                Text(unit)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    CurrentConditionsGrid(temperature: 85.2, humidity: 65, unit: "°F")
        .padding()
}
