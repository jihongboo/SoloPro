//
//  JobFilter.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/13.
//

public enum JobFilter: String, CaseIterable, Identifiable {
    case today = "Today"
    case upcoming = "Upcoming"
    case completed = "Completed"
    case all = "All"

    public var id: String { rawValue }
}
