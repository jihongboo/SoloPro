//
//  WorkVolumeView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import Charts
import SwiftUI

struct WorkVolumeView: View {
    let performanceData: [AnalyticsPerformanceItem]
    let timeDimension: AnalyticsTimeDimension

    var body: some View {
        Chart(performanceData) { item in
            LineMark(
                x: .value(timeDimension.axisLabel, item.startDate, unit: timeDimension.chartUnit),
                y: .value("Jobs", item.jobCount)
            )
            .foregroundStyle(.blue)

            AreaMark(
                x: .value(timeDimension.axisLabel, item.startDate, unit: timeDimension.chartUnit),
                y: .value("Jobs", item.jobCount)
            )
            .foregroundStyle(LinearGradient(
                colors: [
                    .blue.opacity(0.4),
                    .clear],
                startPoint: .top,
                endPoint: .bottom
            ))

            if let average {
                RuleMark(y: .value("Average Jobs", average))
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Avg \(Text(average, format: .number.precision(.fractionLength(1))))")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.thinMaterial, in: Capsule())
                    }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 160)
        .accessibilityLabel("Completed jobs chart")
        .overlay {
            if performanceData.allSatisfy({ $0.jobCount == 0 }) {
                ContentUnavailableView(
                    "No Completed Jobs",
                    systemImage: "chart.line.uptrend.xyaxis",
                )
                .background(Color(uiColor: .secondarySystemGroupedBackground))
            }
        }
    }
}

private extension WorkVolumeView {
    var average: Double? {
        guard !performanceData.isEmpty else { return nil }

        let totalJobs = performanceData.map(\.jobCount).reduce(0, +)
        guard totalJobs > 0 else { return nil }

        return Double(totalJobs) / Double(performanceData.count)
    }
}

#Preview {
    List {
        Section("Work Volume") {
            WorkVolumeView(
                performanceData: [
                    .init(startDate: .now.addingTimeInterval(-2 * 24 * 60 * 60), income: 320, jobCount: 2),
                    .init(startDate: .now.addingTimeInterval(-24 * 60 * 60), income: 180, jobCount: 1),
                    .init(startDate: .now, income: 420, jobCount: 3)
                ],
                timeDimension: .month
            )
        }
        
        Section("Work Volume") {
            WorkVolumeView(
                performanceData: [],
                timeDimension: .month
            )
        }
    }
}
