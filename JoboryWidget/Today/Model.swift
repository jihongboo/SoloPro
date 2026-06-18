//
//  TodayJobSnapshot.swift
//  Jobory
//
//  Created by 纪洪波 on 2026/6/15.
//

import WidgetKit
import Model

struct TodayJobSnapshot: Identifiable {
    let id: UUID
    let date: Date
    let title: String
    let address: String
    let customerName: String?
    let status: JobStatus
}

struct TodayEntry: TimelineEntry {
    let date: Date
    let jobs: [TodayJobSnapshot]
    let focusedJob: TodayJobSnapshot?

    init(date: Date, jobs: [TodayJobSnapshot], focusedJob: TodayJobSnapshot? = nil) {
        self.date = date
        self.jobs = jobs
        self.focusedJob = focusedJob ?? jobs.focusedJob(relativeTo: date)
    }
}

extension Array where Element == TodayJobSnapshot {
    static let preview: [TodayJobSnapshot] = [Job].mock
        .map { job in
            TodayJobSnapshot(
                id: job.id,
                date: job.date,
                title: job.title,
                address: job.address,
                customerName: job.customer?.name,
                status: job.status
            )
        }

    func focusedJob(relativeTo date: Date) -> TodayJobSnapshot? {
        filter { $0.status != .completed && $0.status != .canceled }
            .sorted { lhs, rhs in
                let lhsPriority = priority(for: lhs, relativeTo: date)
                let rhsPriority = priority(for: rhs, relativeTo: date)

                if lhsPriority == rhsPriority {
                    return lhs.date < rhs.date
                }

                return lhsPriority < rhsPriority
            }
            .first
    }

    private func priority(for job: TodayJobSnapshot, relativeTo date: Date) -> Int {
        if job.status == .inProgress { return 0 }
        if job.date < date { return 1 }
        return 2
    }
}
