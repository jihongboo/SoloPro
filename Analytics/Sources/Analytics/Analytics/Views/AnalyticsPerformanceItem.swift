//
//  AnalyticsPerformanceItem.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation

struct AnalyticsPerformanceItem: Equatable, Identifiable {
    let startDate: Date
    let income: Double
    let jobCount: Int

    var id: Date { startDate }
}
