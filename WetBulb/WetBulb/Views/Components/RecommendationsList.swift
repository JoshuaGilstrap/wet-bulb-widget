//
//  RecommendationsList.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import SwiftUI

/// List of safety recommendations
struct RecommendationsList: View {
    let recommendations: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Safety Recommendations")
                .font(.headline)
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(recommendations.enumerated()), id: \.offset) { index, recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.blue)
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 20)

                        Text(recommendation)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    RecommendationsList(recommendations: [
        "Conditions are safe for normal activities",
        "No special precautions needed",
        "Stay hydrated as always"
    ])
    .padding()
}
