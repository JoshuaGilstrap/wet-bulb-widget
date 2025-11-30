//
//  WetBulbWidget.swift
//  WetBulbWidget
//
//  Created by Claude on 11/29/25.
//

import WidgetKit
import SwiftUI

/// Main widget definition
struct WetBulbWidget: Widget {
    let kind: String = "WetBulbWidget"

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

/// Widget entry view that displays different layouts based on widget family
struct WetBulbWidgetEntryView: View {
    var entry: WetBulbWidgetEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            EmptyView()
        }
    }
}

// MARK: - Widget Previews

#Preview(as: .systemSmall) {
    WetBulbWidget()
} timeline: {
    WetBulbWidgetEntry.placeholder
    WetBulbWidgetEntry.example
}

#Preview(as: .systemMedium) {
    WetBulbWidget()
} timeline: {
    WetBulbWidgetEntry.placeholder
    WetBulbWidgetEntry.example
}

#Preview(as: .systemLarge) {
    WetBulbWidget()
} timeline: {
    WetBulbWidgetEntry.placeholder
    WetBulbWidgetEntry.example
}
