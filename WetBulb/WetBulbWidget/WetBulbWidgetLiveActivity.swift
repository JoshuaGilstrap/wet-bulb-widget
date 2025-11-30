//
//  WetBulbWidgetLiveActivity.swift
//  WetBulbWidget
//
//  Created by Joshua Gilstrap on 11/29/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WetBulbWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WetBulbWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WetBulbWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WetBulbWidgetAttributes {
    fileprivate static var preview: WetBulbWidgetAttributes {
        WetBulbWidgetAttributes(name: "World")
    }
}

extension WetBulbWidgetAttributes.ContentState {
    fileprivate static var smiley: WetBulbWidgetAttributes.ContentState {
        WetBulbWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WetBulbWidgetAttributes.ContentState {
         WetBulbWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WetBulbWidgetAttributes.preview) {
   WetBulbWidgetLiveActivity()
} contentStates: {
    WetBulbWidgetAttributes.ContentState.smiley
    WetBulbWidgetAttributes.ContentState.starEyes
}
