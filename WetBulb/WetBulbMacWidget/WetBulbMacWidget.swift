//
//  WetBulbMacWidget.swift
//  WetBulbMacWidget
//
//  Created by Claude on 11/29/25.
//

import WidgetKit
import SwiftUI

/// macOS widget definition
struct WetBulbMacWidget: Widget {
    let kind: String = "WetBulbMacWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WetBulbWidgetProvider()) { entry in
            WetBulbWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Wet Bulb Temperature")
        .description("Shows current wet bulb temperature and heat safety level.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Previews

#Preview(as: .systemSmall) {
    WetBulbMacWidget()
} timeline: {
    WetBulbWidgetEntry.placeholder
    WetBulbWidgetEntry.example
}

#Preview(as: .systemMedium) {
    WetBulbMacWidget()
} timeline: {
    WetBulbWidgetEntry.placeholder
    WetBulbWidgetEntry.example
}

#Preview(as: .systemLarge) {
    WetBulbMacWidget()
} timeline: {
    WetBulbWidgetEntry.placeholder
    WetBulbWidgetEntry.example
}
