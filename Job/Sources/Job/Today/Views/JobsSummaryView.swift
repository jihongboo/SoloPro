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
            .filter { $0.date >= now && $0.status != .completed && $0.status != .canceled }
            .sorted { $0.date < $1.date }
            .first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                SummaryMetricView(title: "Today", value: "\(jobs.count)", caption: jobs.count == 1 ? "Job" : "Jobs")
                SummaryMetricView(title: "Expected", value: expectedIncome.formatted(.currency(code: "USD")), caption: "Income")
            }

            Divider()

            if let nextJob {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Next Job")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(nextJob.title)
                        .font(.headline)
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                        Text(nextJob.date, format: .dateTime.hour().minute())
                        Text("with \(nextJob.customer?.name ?? "No Customer")")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            } else {
                Label("No more jobs scheduled for today", systemImage: "checkmark.circle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    List {
        Section {
            JobsSummaryView(jobs: .mock)
        }
    }
}
