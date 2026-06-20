import SwiftData
import SwiftUI

import Model

public struct TodayJobsPage: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var currentDate: Date
    
    public init(date: Date = Date()) {
        _currentDate = State(initialValue: date)
    }
    
    public var body: some View {
        TodayJobsContent(date: currentDate)
            .id(Calendar.current.startOfDay(for: currentDate))
            .onAppear(perform: refreshCurrentDate)
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    refreshCurrentDate()
                }
            }
    }
}

#Preview(traits: .mock) {
    TodayJobsPage()
}

#Preview("Empty") {
    TodayJobsPage()
}

private extension TodayJobsPage {
    func refreshCurrentDate() {
        let now = Date()
        if !Calendar.current.isDate(currentDate, inSameDayAs: now) {
            currentDate = now
        }
    }
}

private struct TodayJobsContent: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var jobs: [Job]
    
    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition
    
    private let addJobSourceID = "add-job-button"
    
    init(date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        let predicate = #Predicate<Job> { job in
            job.date >= startOfDay && job.date < endOfDay
        }

        _jobs = Query(filter: predicate, sort: \.date)
    }
    
    var body: some View {
        NavigationStack {
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
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
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
}

private extension TodayJobsContent {
    var todayJobs: [Job] {
        jobs
    }
    
    var todayJobStatuses: [JobStatus] {
        todayDisplayOrder.filter { status in
            todayJobs.contains { $0.status == status }
        }
    }
    
    var todayDisplayOrder: [JobStatus] {
        [
            .inProgress,
            .scheduled,
            .completed,
            .canceled
        ]
    }
    
    func todayJobs(for status: JobStatus) -> [Job] {
        todayJobs.filter { $0.status == status }
    }
    
    func deleteJobs(at offsets: IndexSet, status: JobStatus) {
        let sectionJobs = todayJobs(for: status)
        for index in offsets {
            modelContext.delete(sectionJobs[index])
        }
    }
}

