import SwiftData
import SwiftUI
import Model

public struct AnalyticsPage: View {
    @Query(sort: \Job.date) private var jobs: [Job]

    @State private var selectedDimension: AnalyticsTimeDimension = .month

    public init() {}

    public var body: some View {
        List {
            Section(selectedDimension.summaryTitle) {
                AnalyticsSummaryView(
                    timeDimension: selectedDimension,
                    income: selectedIncome,
                    completedJobCount: selectedCompletedJobs.count,
                    upcomingJobCount: selectedUpcomingJobs.count,
                    averagePrice: selectedAveragePrice
                )
            }

            Section("Income Trend") {
                IncomeTrendView(
                    performanceData: performanceData,
                    timeDimension: selectedDimension
                )
            }

            Section("Work Volume") {
                WorkVolumeView(
                    performanceData: performanceData,
                    timeDimension: selectedDimension
                )
            }

            Section {
                StatusAnalyticsStorageView(
                    items: statusBreakdown,
                    total: selectedJobs.count
                )
            } header: {
                HStack {
                    Text("Status usage")
                    Spacer()
                    Text("\(selectedJobs.count) jobs")
                }
            }

            Section("Recent Income") {
                RecentIncomeView(jobs: recentCompletedJobs)
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if jobs.isEmpty {
                ContentUnavailableView(
                    "No Analytics Yet",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Complete jobs to start seeing work and income trends.")
                )
                .background(.background)
            }
        }
        .navigationTitle("Analytics")
        .toolbar {
            Picker(
                "Time Dimension",
                systemImage: "calendar",
                selection: $selectedDimension
            ) {
                ForEach(AnalyticsTimeDimension.allCases) { dimension in
                    Text(dimension.title).tag(dimension)
                }
            }
            .labelsHidden()
            .fixedSize()
        }
    }
}

#Preview {
    NavigationStack {
        AnalyticsPage()
    }
    .modelContainer(.mock)
}

#Preview("Empty") {
    NavigationStack {
        AnalyticsPage()
    }
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
