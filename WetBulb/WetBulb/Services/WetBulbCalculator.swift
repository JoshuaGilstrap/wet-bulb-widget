//
//  WetBulbCalculator.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import Foundation

/// Calculates wet bulb temperature using scientifically validated formulas
struct WetBulbCalculator {

    /// Calculates wet bulb temperature using the Stull (2011) formula
    ///
    /// This formula is meteorologically validated for temperatures between -20°C and 50°C
    /// and relative humidity between 5% and 99%. It provides accuracy within 0.3°C for
    /// most common conditions.
    ///
    /// Reference: Stull, R. (2011). "Wet-Bulb Temperature from Relative Humidity and Air Temperature"
    /// Journal of Applied Meteorology and Climatology, 50(11), 2267-2269.
    ///
    /// - Parameters:
    ///   - temperature: Dry bulb temperature in Celsius
    ///   - humidity: Relative humidity as a percentage (0-100)
    /// - Returns: Wet bulb temperature in Celsius
    static func calculate(temperature: Double, humidity: Double) -> Double {
        let T = temperature
        let RH = humidity

        // Stull (2011) formula
        let Tw = T * atan(0.151977 * sqrt(RH + 8.313659))
               + atan(T + RH)
               - atan(RH - 1.676331)
               + 0.00391838 * pow(RH, 3.0/2.0) * atan(0.023101 * RH)
               - 4.686035

        return Tw
    }

    /// Convert Celsius to Fahrenheit
    /// - Parameter celsius: Temperature in Celsius
    /// - Returns: Temperature in Fahrenheit
    static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return celsius * 9/5 + 32
    }

    /// Convert Fahrenheit to Celsius
    /// - Parameter fahrenheit: Temperature in Fahrenheit
    /// - Returns: Temperature in Celsius
    static func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }

    /// Validate if temperature and humidity are within acceptable ranges
    /// - Parameters:
    ///   - temperature: Temperature in Celsius
    ///   - humidity: Relative humidity percentage
    /// - Returns: True if values are within valid ranges
    static func isValid(temperature: Double, humidity: Double) -> Bool {
        return temperature >= -20 && temperature <= 50 &&
               humidity >= 5 && humidity <= 99
    }
}
