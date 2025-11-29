//
//  WeatherService.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation
import CoreLocation

/// Service for fetching weather data from Open-Meteo API
actor WeatherService {

    /// Errors that can occur during weather data fetching
    enum WeatherError: LocalizedError {
        case invalidURL
        case networkError(Error)
        case invalidResponse
        case decodingError(Error)
        case noData

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid weather service URL"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .invalidResponse:
                return "Invalid response from weather service"
            case .decodingError(let error):
                return "Failed to decode weather data: \(error.localizedDescription)"
            case .noData:
                return "No weather data available"
            }
        }
    }

    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Fetch current weather data for a specific location
    /// - Parameters:
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    /// - Returns: WeatherData object with current conditions
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        // Build URL with query parameters
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m"),
            URLQueryItem(name: "temperature_unit", value: "celsius")
        ]

        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }

        // Fetch data from API
        let (data, response) = try await session.data(from: url)

        // Validate response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WeatherError.invalidResponse
        }

        // Parse JSON response
        do {
            let apiResponse = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)

            // Convert to our WeatherData model
            let weatherData = WeatherData(
                temperature: apiResponse.current.temperature_2m,
                humidity: apiResponse.current.relative_humidity_2m,
                location: LocationInfo(
                    latitude: latitude,
                    longitude: longitude,
                    name: nil // Open-Meteo doesn't provide city name
                ),
                timestamp: Date()
            )

            return weatherData

        } catch {
            throw WeatherError.decodingError(error)
        }
    }

    /// Fetch weather data using a CLLocationCoordinate2D
    /// - Parameter coordinate: Location coordinate
    /// - Returns: WeatherData object
    func fetchWeather(for coordinate: CLLocationCoordinate2D) async throws -> WeatherData {
        try await fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

// MARK: - Open-Meteo API Response Models

/// Response structure from Open-Meteo API
private struct OpenMeteoResponse: Codable {
    let current: CurrentWeather

    struct CurrentWeather: Codable {
        let temperature_2m: Double
        let relative_humidity_2m: Double
    }
}
