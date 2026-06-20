import SwiftData
import SwiftUI
import Model
import Widgets

public struct JobsPage: View {
    @Environment(\.calendar) private var calendar

    @State private var selectedDates: Set<DateComponents> = []
    @State private var statusFilter: JobStatusFilter = .all
    @State private var searchText = ""
    @State private var isPresentingDatePicker = false
    @State private var isPresentingJobForm = false
    @Namespace private var addJobTransition

    private let addJobSourceID = "add-job-button"

    public init() {}

    public var body: some View {
        JobsView(
            dates: selectedDates,
            statusFilter: statusFilter,
            searchText: searchText,
            isPresentingJobForm: $isPresentingJobForm
        )
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

                    if !selectedDates.isEmpty {
                        Button("Clear Date Filter", systemImage: "calendar.badge.minus") {
                            selectedDates = []
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
            DatePickerPage(selectedDates: $selectedDates)
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
    private var dateFilterTitle: String {
        let dates = selectedDates.compactMap { date(from: $0) }.sorted()

        switch dates.count {
        case 0:
            return "All Dates"
        case 1:
            return dates[0].formatted(.dateTime.month(.abbreviated).day().year())
        default:
            return "\(dates.count) Dates"
        }
    }

    private func date(from components: DateComponents) -> Date? {
        calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day
        ))
    }
}

enum JobStatusFilter: String, CaseIterable, Identifiable {
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

    var statusRawValueBounds: (minimum: Int, maximum: Int)? {
        switch self {
        case .all:
            nil
        case .incomplete:
            (JobStatus.scheduled.rawValue, JobStatus.inProgress.rawValue)
        case .completed:
            (JobStatus.completed.rawValue, JobStatus.completed.rawValue)
        case .canceled:
            (JobStatus.canceled.rawValue, JobStatus.canceled.rawValue)
        }
    }
}
