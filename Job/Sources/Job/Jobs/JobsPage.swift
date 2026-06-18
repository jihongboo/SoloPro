import SwiftData
import SwiftUI
import Model
import Widgets

public struct JobsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.date) private var jobs: [Job]

    @State private var selectedDate: Date?
    @State private var statusFilter: JobStatusFilter = .all
    @State private var searchText = ""
    @State private var isPresentingDatePicker = false
    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition

    private let addJobSourceID = "add-job-button"

    public init() {}

    public var body: some View {
        List {
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
        .listStyle(.plain)
        .overlay {
            if filteredJobs.isEmpty {
                ContentUnavailableView {
                    Label("No Jobs Found", systemImage: "square.stack")
                } description: {
                    Text(emptyStateDescription)
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

                    if selectedDate != nil {
                        Button("Clear Date Filter", systemImage: "calendar.badge.minus") {
                            selectedDate = nil
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
            DatePickerPage(selectedDate: $selectedDate)
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

#Preview("Empty") {
    NavigationStack {
        JobsPage()
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

    private var selectedDateInterval: DateInterval? {
        guard let selectedDate else { return nil }
        return Calendar.current.dateInterval(of: .day, for: selectedDate) ?? fallbackDateInterval(for: selectedDate)
    }

    private var dateFilterTitle: String {
        guard let selectedDate else { return "All Dates" }
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
        guard let selectedDateInterval else { return true }
        return selectedDateInterval.contains(date)
    }

    private func fallbackDateInterval(for date: Date) -> DateInterval {
        DateInterval(start: date, duration: 24 * 60 * 60)
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
