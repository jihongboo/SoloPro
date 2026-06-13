//
//  JobStatus.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation
import SwiftData
import SwiftUI

public enum JobStatus: String, Codable, CaseIterable, Identifiable {
    case scheduled
    case inProgress
    case completed
    case canceled

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .scheduled:
            "Scheduled"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        case .canceled:
            "Canceled"
        }
    }

    public var systemImage: String {
        switch self {
        case .scheduled:
            "calendar"
        case .inProgress:
            "hammer"
        case .completed:
            "checkmark.circle.fill"
        case .canceled:
            "xmark.circle.fill"
        }
    }

    public var tint: Color {
        switch self {
        case .scheduled:
            .blue
        case .inProgress:
            .orange
        case .completed:
            .green
        case .canceled:
            .secondary
        }
    }
}
