//
//  SettingsView.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import SwiftUI

/// Settings screen for app preferences
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = AppSettings.shared

    var body: some View {
        NavigationStack {
            Form {
                // Display settings
                Section("Display") {
                    Toggle("Use Fahrenheit", isOn: $settings.useFahrenheit)
                }

                // Safety settings
                Section("Safety") {
                    Picker("Default Activity Level", selection: $settings.defaultActivity) {
                        ForEach(ActivityLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }

                    Text(settings.defaultActivity.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // About section
                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wet Bulb Temperature Widget")
                            .font(.headline)

                        Text("Provides heat safety information based on wet bulb temperature, which combines temperature and humidity for accurate heat danger assessment.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)

                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }

                // Science section
                Section("How It Works") {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(
                            title: "Wet Bulb Temperature",
                            description: "Combines temperature AND humidity to show the body's ability to cool itself through sweat evaporation."
                        )

                        InfoRow(
                            title: "Safety Levels",
                            description: "Color-coded bands from Safe (green) to Extreme Danger (dark red) based on scientifically validated thresholds."
                        )

                        InfoRow(
                            title: "Activity Adjustment",
                            description: "Heat danger increases with physical exertion. Recommendations adjust based on your selected activity level."
                        )
                    }
                }

                // Disclaimer
                Section {
                    Text("This app provides general guidance only. Heat tolerance varies by individual. Consult healthcare professionals for personal advice. In emergency situations, call 911.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Important")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Helper view for info rows
struct InfoRow: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SettingsView()
}
