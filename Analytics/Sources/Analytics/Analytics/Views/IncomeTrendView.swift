//
//  IncomeTrendView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import Charts
import SwiftUI

struct IncomeTrendView: View {
    let performanceData: [AnalyticsPerformanceItem]
    let timeDimension: AnalyticsTimeDimension

    var body: some View {
        Chart(performanceData) { item in
            BarMark(
                x: .value(timeDimension.axisLabel, item.startDate, unit: timeDimension.chartUnit),
                y: .value("Income", item.income)
            )
            .foregroundStyle(.green.gradient)
            .cornerRadius(4)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 160)
        .accessibilityLabel("Income chart")
        .overlay {
            if performanceData.allSatisfy({ $0.income == 0 }) {
                ContentUnavailableView(
                    "No Completed Income",
                    systemImage: "chart.bar.xaxis",
                )
                .background(.background)
            }
        }
    }
}

#Preview {
    List {
        Section("Income Trend") {
            IncomeTrendView(
                performanceData: [
                    .init(startDate: .now.addingTimeInterval(-2 * 24 * 60 * 60), income: 320, jobCount: 2),
                    .init(startDate: .now.addingTimeInterval(-24 * 60 * 60), income: 180, jobCount: 1),
                    .init(startDate: .now, income: 420, jobCount: 3)
                ],
                timeDimension: .month
            )
        }
        
        Section("Income Trend") {
            IncomeTrendView(
                performanceData: [],
                timeDimension: .month
            )
        }
    }
}
