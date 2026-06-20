//
//  JobsQueryContent.swift
//  Job
//
//  Created by 纪洪波 on 6/20/26.
//

import SwiftUI
import SwiftData

import Model

struct JobsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.calendar) private var calendar
    @Query private var jobs: [Job]

    private let dates: Set<DateComponents>
    private let searchText: String
    @Binding private var isPresentingJobForm: Bool

    init(
        dates: Set<DateComponents>,
        statusFilter: JobStatusFilter,
        searchText: String,
        isPresentingJobForm: Binding<Bool>
    ) {
        self.dates = dates
        self.searchText = searchText
        _isPresentingJobForm = isPresentingJobForm
        _jobs = Query(
            filter: JobPredicate.make(
                selectedDates: dates,
                statusFilter: statusFilter,
                searchText: searchText,
                calendar: calendar,
            ),
            sort: \Job.date,
            order: .reverse
        )
    }

    var body: some View {
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
    }
}

private extension JobsView {
    private var filteredJobs: [Job] {
        let dateFilteredJobs: [Job]
        let selectedDateIntervals = selectedDateIntervals

        if selectedDateIntervals.count > 1 {
            dateFilteredJobs = jobs.filter { job in
                selectedDateIntervals.contains { $0.contains(job.date) }
            }
        } else {
            dateFilteredJobs = jobs
        }

        guard !searchQuery.isEmpty else { return dateFilteredJobs }
        return dateFilteredJobs.filter { job in
            job.title.localizedStandardContains(searchQuery) ||
            job.address.localizedStandardContains(searchQuery) ||
            job.notes?.localizedStandardContains(searchQuery) == true ||
            job.customer?.name.localizedStandardContains(searchQuery) == true
        }
    }

    private var jobDateSections: [JobDateSection] {
        let groupedJobs = Dictionary(grouping: filteredJobs) { job in
            calendar.startOfDay(for: job.date)
        }

        return groupedJobs.keys.sorted(by: >).map { date in
            JobDateSection(
                date: date,
                jobs: groupedJobs[date, default: []].sorted { $0.date > $1.date }
            )
        }
    }

    private var selectedDateIntervals: [DateInterval] {
        dates.compactMap { selectedDateInterval(from: $0) }
    }

    private var searchQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var emptyStateDescription: String {
        if searchQuery.isEmpty {
            "Try another date or status filter."
        } else {
            "Try another date, status filter, or search term."
        }
    }

    private func selectedDateInterval(from components: DateComponents) -> DateInterval? {
        guard let date = date(from: components) else { return nil }
        return calendar.dateInterval(of: .day, for: date) ?? fallbackDateInterval(for: date)
    }

    private func date(from components: DateComponents) -> Date? {
        calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day
        ))
    }

    private func fallbackDateInterval(for date: Date) -> DateInterval {
        DateInterval(start: calendar.startOfDay(for: date), duration: 24 * 60 * 60)
    }

    private func deleteJobs(at offsets: IndexSet, in dateSection: JobDateSection) {
        for index in offsets {
            modelContext.delete(dateSection.jobs[index])
        }
    }
}

private enum JobPredicate {
    static func make(
        selectedDates: Set<DateComponents>,
        statusFilter: JobStatusFilter,
        searchText: String,
        calendar: Calendar,
    ) -> Predicate<Job>? {
        let dateBounds = dateFetchBounds(selectedDates: selectedDates, calendar: calendar)
        let statusBounds = statusFilter.statusRawValueBounds

        guard dateBounds != nil || statusBounds != nil else {
            return nil
        }

        let startDate = dateBounds?.start
        let endDate = dateBounds?.end
        let minimumStatusRawValue = statusBounds?.minimum
        let maximumStatusRawValue = statusBounds?.maximum

        return #Predicate<Job> { job in
            (startDate == nil || job.date >= startDate!) &&
            (endDate == nil || job.date < endDate!) &&
            (minimumStatusRawValue == nil || job.statusRawValue >= minimumStatusRawValue!) &&
            (maximumStatusRawValue == nil || job.statusRawValue <= maximumStatusRawValue!)
        }
    }

    private static func dateFetchBounds(
        selectedDates: Set<DateComponents>,
        calendar: Calendar,
    ) -> DateInterval? {
        let intervals = selectedDates
            .compactMap { selectedDateInterval(from: $0, calendar: calendar) }
            .sorted { $0.start < $1.start }

        guard let first = intervals.first, let last = intervals.last else { return nil }
        return DateInterval(start: first.start, end: last.end)
    }

    private static func selectedDateInterval(
        from components: DateComponents,
        calendar: Calendar,
    ) -> DateInterval? {
        guard let date = calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day
        )) else { return nil }

        return calendar.dateInterval(of: .day, for: date) ?? DateInterval(
            start: calendar.startOfDay(for: date),
            duration: 24 * 60 * 60
        )
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
