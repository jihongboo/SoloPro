//
//  FocusedJobWidgetView.swift
//  Jobory
//
//  Created by 纪洪波 on 2026/6/15.
//

import WidgetKit
import SwiftUI
import AppIntents
import Model

struct FocusedJobWidgetView: View {
    let entry: TodayEntry

    @Environment(\.widgetFamily) private var family

    private var job: TodayJobSnapshot? {
        entry.focusedJob
    }

    var body: some View {
        Group {
            if let job {
                jobContent(job)
            } else {
                emptyContent
            }
        }
    }

    private func jobContent(_ job: TodayJobSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label(for: job))
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text(job.title)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                    .lineLimit(family == .systemSmall ? 2 : 1)

                HStack(spacing: 2) {
                    Image(systemName: "clock.fill")
                    Text(job.date, format: .dateTime.weekday(.abbreviated).hour().minute())
                }
                .monospacedDigit()
                
                if let customerName = job.customerName, !customerName.isEmpty {
                    Label(customerName, systemImage: "person.fill")
                        .lineLimit(1)
                }
                
                if family != .systemSmall {
                    if !trimmedAddress(for: job).isEmpty {
                        Label(job.address, systemImage: "location.fill")
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .labelIconToTitleSpacing(2)

            actions(for: job)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func actions(for job: TodayJobSnapshot) -> some View {
        HStack(spacing: 8) {
            Button(intent: AdvanceJobStatusIntent(jobID: job.id)) {
                Label(statusButtonTitle(for: job), systemImage: statusButtonImage(for: job))
                    .frame(maxWidth: .infinity)
            }
            .tint(statusButtonTint(for: job))

            if let navigationURL = navigationURL(for: job) {
                Link(destination: navigationURL) {
                    Label("Navigate", systemImage: "location.fill")
                        .frame(maxWidth: .infinity)
                }
                .tint(.blue)
            }
        }
        .font(.caption.bold())
        .foregroundStyle(.background)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
    }

    private var emptyContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.green)

            Text("All caught up")
                .font(.headline)

            Text("No active jobs")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .multilineTextAlignment(.center)
    }

    private func label(for job: TodayJobSnapshot) -> String {
        if job.status == .inProgress { return "Current Job" }
        if job.date < entry.date { return "Delayed Job" }
        return "Next Job"
    }

    private func statusButtonTitle(for job: TodayJobSnapshot) -> String {
        switch job.status {
        case .scheduled:
            "Start"
        case .inProgress:
            "Complete"
        case .completed, .canceled:
            "Reopen"
        }
    }

    private func statusButtonImage(for job: TodayJobSnapshot) -> String {
        switch job.status {
        case .scheduled:
            "play.fill"
        case .inProgress:
            "checkmark"
        case .completed, .canceled:
            "arrow.counterclockwise"
        }
    }

    private func statusButtonTint(for job: TodayJobSnapshot) -> Color {
        switch job.status {
        case .scheduled:
            .orange
        case .inProgress:
            .green
        case .completed, .canceled:
            .blue
        }
    }

    private func navigationURL(for job: TodayJobSnapshot) -> URL? {
        let address = trimmedAddress(for: job)
        guard !address.isEmpty else { return nil }

        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "daddr", value: address),
            URLQueryItem(name: "dirflg", value: "d")
        ]
        return components?.url
    }

    private func trimmedAddress(for job: TodayJobSnapshot) -> String {
        job.address.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct FocusedJobWidget: Widget {
    let kind: String = "FocusedJobWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayProvider()) { entry in
            FocusedJobWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Current Job")
        .description("Focus on the current job, or the next job when nothing is in progress.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview("Focused Small", as: .systemSmall) {
    FocusedJobWidget()
} timeline: {
    TodayEntry(date: .now, jobs: .preview)
}

#Preview("Focused Medium", as: .systemMedium) {
    FocusedJobWidget()
} timeline: {
    TodayEntry(date: .now, jobs: .preview)
}

#Preview("Focused Empty", as: .systemSmall) {
    FocusedJobWidget()
} timeline: {
    TodayEntry(date: .now, jobs: [])
}
