import SwiftUI
import Model

struct JobsSummaryView: View {
    let jobs: [Job]

    private var expectedIncome: Double {
        jobs
            .filter { $0.status != .canceled }
            .map(\.price)
            .reduce(0, +)
    }

    private var nextJob: Job? {
        let now = Date()
        return jobs
            .filter { $0.status != .completed && $0.status != .canceled }
            .sorted { lhs, rhs in
                let lhsPriority = priority(for: lhs, relativeTo: now)
                let rhsPriority = priority(for: rhs, relativeTo: now)

                if lhsPriority == rhsPriority {
                    return lhs.date < rhs.date
                }

                return lhsPriority < rhsPriority
            }
            .first
    }

    private func priority(for job: Job, relativeTo now: Date) -> Int {
        if job.status == .inProgress { return 0 }
        if job.date < now { return 1 }
        return 2
    }

    var body: some View {
        HStack(spacing: 12) {
            SummaryMetricView(
                title: "Today",
                value: .number(jobs.count),
                caption: jobs.count == 1 ? "Job" : "Jobs"
            )
            SummaryMetricView(
                title: "Expected",
                value: .currency(expectedIncome),
                caption: "Income"
            )
        }

        if let nextJob {
            NextJobView(job: nextJob)
        } else {
            Label("No more jobs scheduled for today", systemImage: "checkmark.circle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }

        TodayDestinationsMapCard(jobs: jobs, routeDestinationJob: nextJob)
    }
}

#Preview {
    List {
        Section {
            JobsSummaryView(jobs: .mock)
        }
    }
}
