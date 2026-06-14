//
//  JoboryWidgetLiveActivity.swift
//  JoboryWidget
//
//  Created by 纪洪波 on 2026/6/15.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct JoboryWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct JoboryWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: JoboryWidgetAttributes.self) { context in
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

extension JoboryWidgetAttributes {
    fileprivate static var preview: JoboryWidgetAttributes {
        JoboryWidgetAttributes(name: "World")
    }
}

extension JoboryWidgetAttributes.ContentState {
    fileprivate static var smiley: JoboryWidgetAttributes.ContentState {
        JoboryWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: JoboryWidgetAttributes.ContentState {
         JoboryWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: JoboryWidgetAttributes.preview) {
   JoboryWidgetLiveActivity()
} contentStates: {
    JoboryWidgetAttributes.ContentState.smiley
    JoboryWidgetAttributes.ContentState.starEyes
}
