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
            .symbol(Circle())

            AreaMark(
                x: .value(timeDimension.axisLabel, item.startDate, unit: timeDimension.chartUnit),
                y: .value("Jobs", item.jobCount)
            )
            .foregroundStyle(.blue.opacity(0.16))
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
            }
        }
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
