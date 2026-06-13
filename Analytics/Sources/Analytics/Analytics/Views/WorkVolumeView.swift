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

    @State private var animationProgress = 0.0

    var body: some View {
        Group {
            if performanceData.allSatisfy({ $0.jobCount == 0 }) {
                ContentUnavailableView(
                    "No Completed Jobs",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Completed jobs will appear in this chart.")
                )
            } else {
                Chart(performanceData) { item in
                    LineMark(
                        x: .value(timeDimension.axisLabel, item.startDate, unit: timeDimension.chartUnit),
                        y: .value("Jobs", Double(item.jobCount) * animationProgress)
                    )
                    .foregroundStyle(.blue)
                    .symbol(Circle())

                    AreaMark(
                        x: .value(timeDimension.axisLabel, item.startDate, unit: timeDimension.chartUnit),
                        y: .value("Jobs", Double(item.jobCount) * animationProgress)
                    )
                    .foregroundStyle(.blue.opacity(0.16))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 160)
                .accessibilityLabel("Completed jobs chart")
            }
        }
        .onAppear(perform: animateChart)
        .onChange(of: performanceData, animateChart)
        .onChange(of: timeDimension, animateChart)
    }

    private func animateChart() {
        animationProgress = 0

        withAnimation(.smooth) {
            animationProgress = 1
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
