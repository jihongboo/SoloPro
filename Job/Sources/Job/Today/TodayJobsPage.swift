import SwiftData
import SwiftUI
import Model

public struct TodayJobsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.date) private var jobs: [Job]
    @AppStorage("didSeedSampleJobs") private var didSeedSampleJobs = false

    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition

    private let addJobSourceID = "add-job-button"

    public init() {}

    public var body: some View {
        List {
            Section {
                JobsSummaryView(jobs: todayJobs)
            }

            Section("Today") {
                if todayJobs.isEmpty {
                    ContentUnavailableView(
                        "No Jobs Today",
                        systemImage: "calendar.badge.plus",
                        description: Text("Add a job to start planning your workday.")
                    )
                } else {
                    ForEach(todayJobs) { job in
                        NavigationLink(value: job) {
                            JobRowView(job: job)
                        }
                    }
                    .onDelete(perform: deleteJobs)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Today Jobs")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                    JobsPage()
                } label: {
                    Label("All Jobs", systemImage: "calendar")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingJobForm = true
                } label: {
                    Label("Add Job", systemImage: "plus")
                }
            }
            .matchedTransitionSource(id: addJobSourceID, in: addJobTransition)
        }
        .navigationDestination(for: Job.self) { job in
            JobPage(job: job)
        }
        .sheet(isPresented: $isPresentingJobForm) {
            JobFormPage(mode: .create)
                .navigationTransition(.zoom(sourceID: addJobSourceID, in: addJobTransition))
        }
        .task {
            seedSampleJobsIfNeeded()
        }
    }
}

#Preview {
    NavigationStack {
        TodayJobsPage()
            .modelContainer(.mock)
    }
}

private extension TodayJobsPage {
    private var todayJobs: [Job] {
        jobs.filter { Calendar.current.isDateInToday($0.date) && $0.status != .canceled }
    }
    
    private func deleteJobs(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(todayJobs[index])
        }
    }

    private func seedSampleJobsIfNeeded() {
        guard !didSeedSampleJobs, jobs.isEmpty else { return }
        [Job].mock.forEach(modelContext.insert)
        [Customer].mock.forEach(modelContext.insert)
        didSeedSampleJobs = true
    }
}
