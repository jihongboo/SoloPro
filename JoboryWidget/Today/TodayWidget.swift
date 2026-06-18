//
//  TodayWidget.swift
//  JoboryWidget
//
//  Created by Gemini on 2026/6/15.
//

import WidgetKit
import SwiftUI
import SwiftData
import Model

struct TodayWidgetView: View {
    var entry: TodayEntry

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                HStack {
                    Text("Today")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(entry.jobs.count) Jobs")
                        .font(.callout.bold())
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 4) {
                ForEach(entry.jobs.prefix(4)) { job in
                    HStack(alignment: .firstTextBaseline) {
                        Text(job.date, style: .time)
                            .font(.body.bold())
                            .monospacedDigit()
                        
                        Spacer()
                        
                        Text(job.title)
                            .font(.callout)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity)
            .overlay {
                if entry.jobs.isEmpty {
                    VStack(spacing: 8) {
                        Spacer()
                        Image(systemName: "calendar.badge.clock")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No jobs for today")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct TodayWidget: Widget {
    let kind: String = "TodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayProvider()) { entry in
            TodayWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Today's Schedule")
        .description("View your jobs for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview("Small", as: .systemSmall) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: .preview)
}

#Preview("Small Empty", as: .systemSmall) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: [])
}

#Preview("Medium", as: .systemMedium) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: .preview)
}

#Preview("Medium Empty", as: .systemMedium) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: [])
}

