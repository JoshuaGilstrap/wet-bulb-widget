//
//  ContentView.swift
//  WetBulb
//
//  Created by Joshua Gilstrap on 11/29/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = WeatherViewModel()
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                if viewModel.isLoading && viewModel.weatherData == nil {
                    LoadingView()
                } else if let weatherData = viewModel.weatherData,
                          let safetyLevel = viewModel.currentSafetyLevel {
                    MainDataView(
                        viewModel: viewModel,
                        weatherData: weatherData,
                        safetyLevel: safetyLevel
                    )
                } else if viewModel.errorMessage != nil {
                    ErrorView(
                        message: viewModel.errorMessage ?? "Unknown error",
                        onRetry: {
                            Task {
                                await viewModel.loadWeather()
                            }
                        }
                    )
                } else {
                    ErrorView(
                        message: "No weather data available",
                        onRetry: {
                            Task {
                                await viewModel.loadWeather()
                            }
                        }
                    )
                }
            }
            .navigationTitle("Wet Bulb Temperature")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .task {
                // Load weather on appear
                if viewModel.weatherData == nil {
                    await viewModel.loadWeather()
                }
            }
        }
    }
}

// MARK: - Main Data View

struct MainDataView: View {
    @Bindable var viewModel: WeatherViewModel
    let weatherData: WeatherData
    let safetyLevel: SafetyLevel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Location info
                LocationHeaderView(
                    coordinates: weatherData.location.coordinateString,
                    lastUpdate: viewModel.lastUpdateText
                )

                // Main wet bulb display
                if let wetBulbTemp = viewModel.displayWetBulbTemp {
                    WetBulbDisplayCard(
                        wetBulbTemp: wetBulbTemp,
                        safetyLevel: safetyLevel,
                        unit: viewModel.temperatureUnit
                    )
                }

                // Current conditions
                if let dryTemp = viewModel.displayDryTemp {
                    CurrentConditionsGrid(
                        temperature: dryTemp,
                        humidity: weatherData.humidity,
                        unit: viewModel.temperatureUnit
                    )
                }

                // Activity selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activity Level")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Picker("Activity Level", selection: $viewModel.selectedActivity) {
                        ForEach(ActivityLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Recommendations
                if !viewModel.recommendations.isEmpty {
                    RecommendationsList(recommendations: viewModel.recommendations)
                }

                // Refresh button
                Button {
                    Task {
                        await viewModel.refresh()
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading)

                // Warning banner if using cached/old data
                if let error = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

// MARK: - Location Header

struct LocationHeaderView: View {
    let coordinates: String
    let lastUpdate: String

    var body: some View {
        VStack(spacing: 4) {
            Text(coordinates)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("Updated \(lastUpdate)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)

            Text("Loading weather data...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Error View

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundStyle(.orange)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
