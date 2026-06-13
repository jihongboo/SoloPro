//
//  AnalyticsMetricValue.swift
//  Widgets
//
//  Created by 纪洪波 on 2026/6/13.
//

public enum AnimatedValue: Equatable {
    case number(Double)
    case currency(Double)
    
    public var amount: Double {
        switch self {
        case .number(let value), .currency(let value):
            value
        }
    }
}
