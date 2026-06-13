import Charts
import SwiftData
import SwiftUI
import Model

public struct AnalyticsPage: View {
    @Query(sort: \Job.date) private var jobs: [Job]

    @State private var selectedDimension: AnalyticsTimeDimension = .month

    public init() {}

    public var body: some View {
        List {
            Section {
                Picker("Time Dimension", selection: $selectedDimension) {
                    ForEach(AnalyticsTimeDimension.allCases) { dimension in
                        Text(dimension.title).tag(dimension)
                    }
                }
                .pickerStyle(.segmented)
            }

            if jobs.isEmpty {
                ContentUnavailableView(
                    "No Analytics Yet",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Complete jobs to start seeing work and income trends.")
                )
            } else {
                Section {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(selectedDimension.summaryTitle)
                            .font(.headline)

                        HStack(spacing: 12) {
                            AnalyticsMetricView(
                                title: "Income",
                                value: selectedIncome.formatted(.currency(code: "USD")),
                                caption: "Completed jobs",
                                systemImage: "dollarsign.circle.fill",
                                tint: .green
                            )

                            AnalyticsMetricView(
                                title: "Jobs",
                                value: "\(selectedCompletedJobs.count)",
                                caption: "Finished work",
                                systemImage: "checkmark.circle.fill",
                                tint: .blue
                            )
                        }

                        HStack(spacing: 12) {
                            AnalyticsMetricView(
                                title: "Scheduled",
                                value: "\(selectedUpcomingJobs.count)",
                                caption: "Upcoming",
                                systemImage: "calendar.circle.fill",
                                tint: .orange
                            )

                            AnalyticsMetricView(
                                title: "Average",
                                value: selectedAveragePrice.formatted(.currency(code: "USD")),
                                caption: "Per completed job",
                                systemImage: "dollarsign.arrow.circlepath",
                                tint: .purple
                            )
                        }
                    }
                }

                Section("Income Trend") {
                    if performanceData.allSatisfy({ $0.income == 0 }) {
                        ContentUnavailableView(
                            "No Completed Income",
                            systemImage: "chart.bar.xaxis",
                            description: Text("Completed jobs will appear in this chart.")
                        )
                    } else {
                        Chart(performanceData) { item in
                            BarMark(
                                x: .value(selectedDimension.axisLabel, item.startDate, unit: selectedDimension.chartUnit),
                                y: .value("Income", item.income)
                            )
                            .foregroundStyle(.green.gradient)
                            .cornerRadius(4)
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .frame(height: 180)
                        .accessibilityLabel("Income chart")
                    }
                }

                Section("Work Volume") {
                    Chart(performanceData) { item in
                        LineMark(
                            x: .value(selectedDimension.axisLabel, item.startDate, unit: selectedDimension.chartUnit),
                            y: .value("Jobs", item.jobCount)
                        )
                        .foregroundStyle(.blue)
                        .symbol(Circle())

                        AreaMark(
                            x: .value(selectedDimension.axisLabel, item.startDate, unit: selectedDimension.chartUnit),
                            y: .value("Jobs", item.jobCount)
                        )
                        .foregroundStyle(.blue.opacity(0.16))
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 160)
                    .accessibilityLabel("Completed jobs chart")
                }

                Section("Status") {
                    ForEach(statusBreakdown) { item in
                        StatusAnalyticsRowView(item: item, total: selectedJobs.count)
                    }
                }

                Section("Recent Income") {
                    if recentCompletedJobs.isEmpty {
                        ContentUnavailableView(
                            "No Recent Income",
                            systemImage: "tray",
                            description: Text("Finished jobs with a price will appear here.")
                        )
                    } else {
                        ForEach(recentCompletedJobs) { job in
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(job.title)
                                        .font(.headline)
                                    Text(job.date, format: .dateTime.month(.abbreviated).day().year())
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(job.price.formatted(.currency(code: "USD")))
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Analytics")
    }
}

#Preview {
    NavigationStack {
        AnalyticsPage()
    }
    .modelContainer(.mock)
}

private extension AnalyticsPage {
    private var completedJobs: [Job] {
        jobs.filter { $0.status == .completed }
    }

    private var selectedJobs: [Job] {
        jobs.filter { selectedInterval.contains($0.date) }
    }

    private var selectedCompletedJobs: [Job] {
        completedJobs.filter { selectedInterval.contains($0.date) }
    }

    private var selectedIncome: Double {
        selectedCompletedJobs.map(\.price).reduce(0, +)
    }

    private var selectedUpcomingJobs: [Job] {
        let now = Date()
        return selectedJobs.filter { job in
            job.date >= now && job.status != .completed && job.status != .canceled
        }
    }

    private var selectedAveragePrice: Double {
        guard !selectedCompletedJobs.isEmpty else { return 0 }
        return selectedIncome / Double(selectedCompletedJobs.count)
    }

    private var recentCompletedJobs: [Job] {
        selectedCompletedJobs
            .filter { $0.price > 0 }
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }

    private var performanceData: [AnalyticsPerformanceItem] {
        let calendar = Calendar.current

        return bucketStartDates.map { startDate in
            let interval = calendar.dateInterval(of: selectedDimension.bucketComponent, for: startDate) ?? selectedDimension.fallbackInterval(startingAt: startDate)
            let jobsInBucket = completedJobs.filter { interval.contains($0.date) }

            return AnalyticsPerformanceItem(
                startDate: startDate,
                income: jobsInBucket.map(\.price).reduce(0, +),
                jobCount: jobsInBucket.count
            )
        }
    }

    private var statusBreakdown: [StatusAnalyticsItem] {
        JobStatus.allCases.map { status in
            StatusAnalyticsItem(
                status: status,
                count: selectedJobs.filter { $0.status == status }.count
            )
        }
    }

    private var selectedInterval: DateInterval {
        Calendar.current.dateInterval(of: selectedDimension.intervalComponent, for: Date()) ?? selectedDimension.fallbackInterval(startingAt: Date())
    }

    private var bucketStartDates: [Date] {
        switch selectedDimension {
        case .day:
            return dates(in: selectedInterval, component: .hour, count: 24)
        case .month:
            return dates(in: selectedInterval, component: .day, count: Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 31)
        case .year:
            return dates(in: selectedInterval, component: .month, count: 12)
        }
    }

    private func dates(in interval: DateInterval, component: Calendar.Component, count: Int) -> [Date] {
        let calendar = Calendar.current
        return (0..<count).compactMap { offset in
            calendar.date(byAdding: component, value: offset, to: interval.start)
        }
    }
}



private struct AnalyticsPerformanceItem: Identifiable {
    let startDate: Date
    let income: Double
    let jobCount: Int

    var id: Date { startDate }
}

