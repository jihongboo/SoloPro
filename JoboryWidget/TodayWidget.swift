//
//  TodayWidget.swift
//  JoboryWidget
//
//  Created by Gemini on 2026/6/15.
//

import WidgetKit
import SwiftUI
import Model

struct TodayEntry: TimelineEntry {
    let date: Date
    let jobs: [Job]
}

struct TodayProvider: TimelineProvider {
    typealias Entry = TodayEntry

    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: Date(), jobs: .mock)
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> ()) {
        let entry = TodayEntry(date: Date(), jobs: .mock)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> ()) {
        let entry = TodayEntry(date: Date(), jobs: .mock)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

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
            
            VStack {
                ForEach(entry.jobs.prefix(4), id: \.id) { job in
                    HStack {
                        Text(job.date, style: .time)
                            .font(.body.bold())
                            .monospacedDigit()
                        
                        Spacer()
                                                
                        Text(job.customer?.name ?? "Unknown")
                            .font(.callout)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity)
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
    TodayEntry(date: .now, jobs: .mock)
}

#Preview("Small Empty", as: .systemSmall) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: [])
}

#Preview("Medium", as: .systemMedium) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: .mock)
}

#Preview("Large", as: .systemLarge) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, jobs: .mock)
}

//#Preview("ExtraLarge", as: .systemExtraLarge) {
//    TodayWidget()
//} timeline: {
//    TodayEntry(date: .now, jobs: .mock)
//}
