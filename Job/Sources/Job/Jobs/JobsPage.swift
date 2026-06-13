import SwiftData
import SwiftUI
import Model

public struct JobsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.date) private var jobs: [Job]

    @State private var selectedDate = Date()
    @State private var statusFilter: JobStatusFilter = .all
    @State private var searchText = ""
    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition

    private let addJobSourceID = "add-job-button"

    public init() {}

    public var body: some View {
        List {
            Section {
                DatePicker(
                    "Selected Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
            }

            Section(listSectionTitle) {
                if filteredJobs.isEmpty {
                    ContentUnavailableView(
                        "No Jobs Found",
                        systemImage: "calendar",
                        description: Text(emptyStateDescription)
                    )
                } else {
                    ForEach(filteredJobs) { job in
                        NavigationLink(value: job) {
                            JobRowView(job: job)
                        }
                    }
                    .onDelete(perform: deleteJobs)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("All Jobs")
        .searchable(text: $searchText, prompt: "Search jobs")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Picker("Status", selection: $statusFilter) {
                        ForEach(JobStatusFilter.allCases) { filter in
                            Label(filter.title, systemImage: filter.systemImage).tag(filter)
                        }
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }

                Button {
                    isPresentingJobForm = true
                } label: {
                    Label("Add Job", systemImage: "plus")
                }
                .matchedTransitionSource(id: addJobSourceID, in: addJobTransition)
            }
        }
        .navigationDestination(for: Job.self) { job in
            JobPage(job: job)
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
            selectedDateInterval.contains(job.date) &&
            statusFilter.includes(job.status) &&
            job.matchesSearch(searchText)
        }
    }

    private var selectedDateInterval: DateInterval {
        Calendar.current.dateInterval(of: .day, for: selectedDate) ?? fallbackDateInterval
    }

    private var fallbackDateInterval: DateInterval {
        DateInterval(start: selectedDate, duration: 24 * 60 * 60)
    }

    private var listSectionTitle: String {
        "\(statusFilter.title) Jobs - \(selectedDate.formatted(.dateTime.month(.abbreviated).day().year()))"
    }

    private var emptyStateDescription: String {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            "Try another date or status filter."
        } else {
            "Try another date, status filter, or search term."
        }
    }

    private func deleteJobs(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredJobs[index])
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
            "checkmark.circle"
        case .canceled:
            "xmark.circle"
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
