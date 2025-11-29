//
//  WetBulbDisplayCard.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import SwiftUI

/// Large, color-coded card displaying wet bulb temperature and safety level
struct WetBulbDisplayCard: View {
    let wetBulbTemp: Double
    let safetyLevel: SafetyLevel
    let unit: String

    var body: some View {
        VStack(spacing: 12) {
            // Large temperature display
            HStack(alignment: .top, spacing: 4) {
                Text(String(format: "%.1f", wetBulbTemp))
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                Text(unit)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .opacity(0.9)
                    .padding(.top, 8)
            }
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)

            // Safety level label
            Text(safetyLevel.label.uppercased())
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(
            LinearGradient(
                colors: safetyLevel.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 20) {
        WetBulbDisplayCard(wetBulbTemp: 72.5, safetyLevel: .safe, unit: "°F")
        WetBulbDisplayCard(wetBulbTemp: 28.3, safetyLevel: .warning, unit: "°C")
        WetBulbDisplayCard(wetBulbTemp: 95.8, safetyLevel: .extreme, unit: "°F")
    }
    .padding()
}
