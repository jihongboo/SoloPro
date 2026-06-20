import SwiftData
import SwiftUI
import Model

public struct TodayJobsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.date) private var jobs: [Job]
    
    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition
    
    private let addJobSourceID = "add-job-button"
    
    public init() {}
    
    public var body: some View {
        List {
            Section {
                JobsSummaryView(jobs: todayJobs)
            }
            
            ForEach(todayJobStatuses) { status in
                Section(status.title) {
                    ForEach(todayJobs(for: status)) { job in
                        NavigationLink(value: job) {
                            JobRowView(job: job)
                        }
                    }
                    .onDelete { offsets in
                        deleteJobs(at: offsets, status: status)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if todayJobs.isEmpty {
                ContentUnavailableView {
                    Label("No Jobs Today", systemImage: "calendar.badge.plus")
                } description: {
                    Text("Add a job to start planning your workday.")
                } actions: {
                    Button {
                        isPresentingJobForm = true
                    } label: {
                        Label("Add Job", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .background(.background)
            }
        }
        .navigationTitle("Today")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink(value: Route.jobs) {
                    Label("All Jobs", systemImage: "square.stack")
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
        .navigationDestination(for: Route.self) { route in
            JobsPage()
        }
        .sheet(isPresented: $isPresentingJobForm) {
            JobFormPage(mode: .create)
                .navigationTransition(.zoom(sourceID: addJobSourceID, in: addJobTransition))
        }
    }
}

#Preview {
    NavigationStack {
        TodayJobsPage()
            .modelContainer(.mock)
    }
}

#Preview("Empty") {
    NavigationStack {
        TodayJobsPage()
    }
}

private extension TodayJobsPage {
    private var todayJobs: [Job] {
        jobs.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    private var todayJobStatuses: [JobStatus] {
        todayDisplayOrder.filter { status in
            todayJobs.contains { $0.status == status }
        }
    }
    
    private var todayDisplayOrder: [JobStatus] {
        [
            .inProgress,
            .scheduled,
            .completed,
            .canceled
        ]
    }
    
    private func todayJobs(for status: JobStatus) -> [Job] {
        todayJobs.filter { $0.status == status }
    }
    
    private func deleteJobs(at offsets: IndexSet, status: JobStatus) {
        let sectionJobs = todayJobs(for: status)
        for index in offsets {
            modelContext.delete(sectionJobs[index])
        }
    }
}

