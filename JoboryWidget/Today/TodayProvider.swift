//
//  TodayProvider.swift
//  Jobory
//
//  Created by 纪洪波 on 2026/6/15.
//

import WidgetKit
import SwiftData

import Model

struct TodayProvider: TimelineProvider {
    typealias Entry = TodayEntry

    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: Date(), jobs: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> Void) {
        let now = Date()
        let jobs: [TodayJobSnapshot] = context.isPreview ? .preview : loadTodayJobs(at: now)
        let focusedJob = context.isPreview ? jobs.focusedJob(relativeTo: now) : loadFocusedJob(at: now)
        completion(TodayEntry(date: now, jobs: jobs, focusedJob: focusedJob))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> Void) {
        let now = Date()
        let entry = TodayEntry(
            date: now,
            jobs: loadTodayJobs(at: now),
            focusedJob: loadFocusedJob(at: now)
        )
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: now) ?? now.addingTimeInterval(900)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

private extension TodayProvider {
    func loadTodayJobs(at date: Date = Date()) -> [TodayJobSnapshot] {
        do {
            let container = ModelContainer.shared
            let context = ModelContext(container)
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

            let predicate = #Predicate<Job> { job in
                job.date >= startOfDay && job.date < endOfDay
            }
            let descriptor = FetchDescriptor<Job>(
                predicate: predicate,
                sortBy: [SortDescriptor(\Job.date)]
            )

            return try context.fetch(descriptor).map(\.snapshot)
        } catch {
            return []
        }
    }

    func loadFocusedJob(at date: Date = Date()) -> TodayJobSnapshot? {
        do {
            let container = ModelContainer.shared
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Job>(
                sortBy: [SortDescriptor(\Job.date)]
            )

            return try context.fetch(descriptor)
                .map(\.snapshot)
                .focusedJob(relativeTo: date)
        } catch {
            return nil
        }
    }
}

private extension Job {
    var snapshot: TodayJobSnapshot {
        TodayJobSnapshot(
            id: id,
            date: date,
            title: title,
            address: address,
            customerName: customer?.name,
            status: status
        )
    }
}
