//
//  LocationService.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation
import CoreLocation
import Observation

/// Service for managing location permissions and updates
@Observable
class LocationService: NSObject, CLLocationManagerDelegate {

    /// Current location data
    private(set) var currentLocation: CLLocation?

    /// Current authorization status
    private(set) var authorizationStatus: CLAuthorizationStatus

    /// Error message if location fetch fails
    private(set) var errorMessage: String?

    /// Whether location is currently being fetched
    private(set) var isLoading = false

    private let manager: CLLocationManager
    private var continuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        self.manager = CLLocationManager()
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer // We don't need precise location
    }

    /// Request location permission and fetch current location
    /// - Returns: Current CLLocation
    func requestLocation() async throws -> CLLocation {
        isLoading = true
        errorMessage = nil

        // Check current authorization status
        let status = manager.authorizationStatus

        // Request permission if needed
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
            // Wait for authorization decision
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        }

        // Check if we have permission
        guard manager.authorizationStatus == .authorizedWhenInUse ||
              manager.authorizationStatus == .authorizedAlways else {
            isLoading = false
            throw LocationError.permissionDenied
        }

        // Request location
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    /// Check if location services are available and authorized
    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isLoading = false

        guard let location = locations.last else {
            continuation?.resume(throwing: LocationError.noLocation)
            continuation = nil
            return
        }

        currentLocation = location
        continuation?.resume(returning: location)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        continuation?.resume(throwing: LocationError.fetchFailed(error))
        continuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

// MARK: - Location Errors

enum LocationError: LocalizedError {
    case permissionDenied
    case noLocation
    case fetchFailed(Error)

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied. Please enable in Settings."
        case .noLocation:
            return "Unable to determine your location"
        case .fetchFailed(let error):
            return "Location fetch failed: \(error.localizedDescription)"
        }
    }
}
