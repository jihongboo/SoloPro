//
//  File.swift
//  Analytics
//
//  Created by 纪洪波 on 6/20/26.
//

import SwiftUI
import SwiftData

import Model

struct AnalyticsView: View {
    @Query private var jobs: [Job]
    
    private let dimension: AnalyticsTimeDimension
    
    init(dimension: AnalyticsTimeDimension) {
        self.dimension = dimension
        let interval = dimension.interval(containing: Date())
        let startDate = interval.start
        let endDate = interval.end
        let predicate = #Predicate<Job> { job in
            job.date >= startDate && job.date < endDate
        }
        
        _jobs = Query(filter: predicate, sort: \Job.date)
    }
    
    var body: some View {
        List {
            Section(dimension.summaryTitle) {
                AnalyticsSummaryView(
                    timeDimension: dimension,
                    income: selectedIncome,
                    completedJobCount: selectedCompletedJobs.count,
                    upcomingJobCount: selectedUpcomingJobs.count,
                    averagePrice: selectedAveragePrice
                )
            }
            
            Section("Income Trend") {
                IncomeTrendView(
                    performanceData: performanceData,
                    timeDimension: dimension
                )
            }
            
            Section("Work Volume") {
                WorkVolumeView(
                    performanceData: performanceData,
                    timeDimension: dimension
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
                .background(Color(uiColor: .secondarySystemGroupedBackground))
            }
        }
    }
}

private extension AnalyticsView {
    private var completedJobs: [Job] {
        jobs.filter { $0.status == .completed }
    }
    
    private var selectedJobs: [Job] {
        jobs
    }
    
    private var selectedCompletedJobs: [Job] {
        completedJobs
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
            let interval = calendar.dateInterval(of: dimension.bucketComponent, for: startDate) ?? dimension.fallbackInterval(startingAt: startDate)
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
        dimension.interval(containing: Date())
    }
    
    private var bucketStartDates: [Date] {
        switch dimension {
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

private extension AnalyticsTimeDimension {
    func interval(containing date: Date) -> DateInterval {
        Calendar.current.dateInterval(of: intervalComponent, for: date) ?? fallbackInterval(startingAt: date)
    }
}
