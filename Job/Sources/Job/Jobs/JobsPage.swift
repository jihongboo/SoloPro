import SwiftData
import SwiftUI
import Model

public struct JobsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.date) private var jobs: [Job]

    @State private var selectedDate = Date()
    @State private var isDateFilterEnabled = false
    @State private var statusFilter: JobStatusFilter = .all
    @State private var searchText = ""
    @State private var isPresentingDatePicker = false
    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition

    private let addJobSourceID = "add-job-button"

    public init() {}

    public var body: some View {
        List {
            if filteredJobs.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No Jobs Found",
                        systemImage: "calendar",
                        description: Text(emptyStateDescription)
                    )
                }
            } else {
                ForEach(jobDateSections) { dateSection in
                    Section(dateSection.title) {
                        ForEach(dateSection.jobs) { job in
                            NavigationLink(value: job) {
                                JobRowView(job: job)
                            }
                        }
                        .onDelete { offsets in
                            deleteJobs(at: offsets, in: dateSection)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("All Jobs")
        .searchable(text: $searchText, prompt: "Search jobs")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingJobForm = true
                } label: {
                    Label("Add Job", systemImage: "plus")
                }
                .matchedTransitionSource(id: addJobSourceID, in: addJobTransition)
            }
            
            ToolbarItem {
                Menu("Filters", systemImage: "line.3.horizontal.decrease") {
                    Button(dateFilterTitle, systemImage: "calendar") {
                        isPresentingDatePicker = true
                    }

                    if isDateFilterEnabled {
                        Button("Clear Date Filter", systemImage: "calendar.badge.minus") {
                            isDateFilterEnabled = false
                        }
                    }

                    Menu("Status: \(statusFilter.title)", systemImage: statusFilter.systemImage) {
                        Picker("Status", selection: $statusFilter) {
                            ForEach(JobStatusFilter.allCases) { filter in
                                Label(filter.title, systemImage: filter.systemImage)
                                    .tag(filter)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingDatePicker) {
            NavigationStack {
                List {
                    Section {
                        DatePicker(
                            "Date",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                    }

                    Section {
                        Button("Show All Dates") {
                            isDateFilterEnabled = false
                            isPresentingDatePicker = false
                        }
                    }
                }
                .navigationTitle("Select Date")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            isDateFilterEnabled = true
                            isPresentingDatePicker = false
                        }
                    }

                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresentingDatePicker = false
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $isPresentingJobForm) {
            JobFormPage(mode: .create)
                .navigationTransition(.zoom(sourceID: addJobSourceID, in: addJobTransition))
        }
    }
}

#Preview {
    NavigationStack {
        JobsPage()
            .modelContainer(.mock)
    }
}

private extension JobsPage {
    private var filteredJobs: [Job] {
        jobs.filter { job in
            dateFilterIncludes(job.date) &&
            statusFilter.includes(job.status) &&
            job.matchesSearch(searchText)
        }
    }

    private var jobDateSections: [JobDateSection] {
        let groupedJobs = Dictionary(grouping: filteredJobs) { job in
            Calendar.current.startOfDay(for: job.date)
        }

        return groupedJobs.keys.sorted().map { date in
            JobDateSection(
                date: date,
                jobs: groupedJobs[date, default: []].sorted { $0.date < $1.date }
            )
        }
    }

    private var selectedDateInterval: DateInterval {
        Calendar.current.dateInterval(of: .day, for: selectedDate) ?? fallbackDateInterval
    }

    private var fallbackDateInterval: DateInterval {
        DateInterval(start: selectedDate, duration: 24 * 60 * 60)
    }

    private var dateFilterTitle: String {
        guard isDateFilterEnabled else { return "All Dates" }
        return selectedDate.formatted(.dateTime.month(.abbreviated).day().year())
    }

    private var emptyStateDescription: String {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            "Try another date or status filter."
        } else {
            "Try another date, status filter, or search term."
        }
    }

    private func dateFilterIncludes(_ date: Date) -> Bool {
        guard isDateFilterEnabled else { return true }
        return selectedDateInterval.contains(date)
    }

    private func deleteJobs(at offsets: IndexSet, in dateSection: JobDateSection) {
        for index in offsets {
            modelContext.delete(dateSection.jobs[index])
        }
    }
}

private extension Job {
    func matchesSearch(_ searchText: String) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        return searchableValues.contains { value in
            value.localizedCaseInsensitiveContains(query)
        }
    }

    private var searchableValues: [String] {
        [
            title,
            customer?.name,
            address,
            notes,
            status.title,
            price.formatted(.currency(code: "USD"))
        ].compactMap { $0 }
    }
}

private struct JobDateSection: Identifiable {
    let date: Date
    let jobs: [Job]

    var id: Date { date }

    var title: String {
        date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day().year())
    }
}

private enum JobStatusFilter: String, CaseIterable, Identifiable {
    case all
    case incomplete
    case completed
    case canceled

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            "All"
        case .incomplete:
            "Incomplete"
        case .completed:
            "Completed"
        case .canceled:
            "Canceled"
        }
    }

    var systemImage: String {
        switch self {
        case .all:
            "tray.full"
        case .incomplete:
            "clock"
        case .completed:
            JobStatus.completed.systemImage
        case .canceled:
            JobStatus.canceled.systemImage
        }
    }

    func includes(_ status: JobStatus) -> Bool {
        switch self {
        case .all:
            true
        case .incomplete:
            status == .scheduled || status == .inProgress
        case .completed:
            status == .completed
        case .canceled:
            status == .canceled
        }
    }
}
