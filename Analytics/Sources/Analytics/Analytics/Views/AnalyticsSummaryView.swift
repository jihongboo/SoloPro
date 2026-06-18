//
//  AnalyticsSummaryView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI

struct AnalyticsSummaryView: View {
    let timeDimension: AnalyticsTimeDimension
    let income: Double
    let completedJobCount: Int
    let upcomingJobCount: Int
    let averagePrice: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                AnalyticsMetricView(
                    title: "Income",
                    value: .currency(income),
                    caption: "Completed jobs",
                    systemImage: "dollarsign.circle.fill",
                    tint: .green
                )

                AnalyticsMetricView(
                    title: "Jobs",
                    value: .number(Double(completedJobCount)),
                    caption: "Finished work",
                    systemImage: "checkmark.circle.fill",
                    tint: .blue
                )
            }

            HStack(spacing: 12) {
                AnalyticsMetricView(
                    title: "Scheduled",
                    value: .number(Double(upcomingJobCount)),
                    caption: "Upcoming",
                    systemImage: "calendar.circle.fill",
                    tint: .orange
                )

                AnalyticsMetricView(
                    title: "Average",
                    value: .currency(averagePrice),
                    caption: "Per completed job",
                    systemImage: "dollarsign.arrow.circlepath",
                    tint: .purple
                )
            }
        }
    }
}

#Preview {
    List {
        Section {
            AnalyticsSummaryView(
                timeDimension: .month,
                income: 1280,
                completedJobCount: 8,
                upcomingJobCount: 3,
                averagePrice: 160
            )
        }
    }
}
