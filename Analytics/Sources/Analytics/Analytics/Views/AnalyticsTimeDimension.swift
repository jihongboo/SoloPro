//
//  AnalyticsTimeDimension.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation


enum AnalyticsTimeDimension: String, CaseIterable, Identifiable {
    case day
    case month
    case year

    var id: String { rawValue }

    var title: String {
        switch self {
        case .day:
            "Day"
        case .month:
            "Month"
        case .year:
            "Year"
        }
    }

    var summaryTitle: String {
        switch self {
        case .day:
            "Today"
        case .month:
            "This Month"
        case .year:
            "This Year"
        }
    }

    var axisLabel: String {
        switch self {
        case .day:
            "Hour"
        case .month:
            "Day"
        case .year:
            "Month"
        }
    }

    var intervalComponent: Calendar.Component {
        switch self {
        case .day:
            .day
        case .month:
            .month
        case .year:
            .year
        }
    }

    var bucketComponent: Calendar.Component {
        switch self {
        case .day:
            .hour
        case .month:
            .day
        case .year:
            .month
        }
    }

    var chartUnit: Calendar.Component {
        bucketComponent
    }

    func fallbackInterval(startingAt startDate: Date) -> DateInterval {
        switch self {
        case .day:
            DateInterval(start: startDate, duration: 24 * 60 * 60)
        case .month:
            DateInterval(start: startDate, duration: 30 * 24 * 60 * 60)
        case .year:
            DateInterval(start: startDate, duration: 365 * 24 * 60 * 60)
        }
    }
}
