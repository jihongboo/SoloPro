//
//  AnalyticsMetricValue.swift
//  Widgets
//
//  Created by 纪洪波 on 2026/6/13.
//

public protocol AnimatedNumericValue {
    var animatedDoubleValue: Double { get }
}

extension Double: AnimatedNumericValue {
    public var animatedDoubleValue: Double { self }
}

extension Int: AnimatedNumericValue {
    public var animatedDoubleValue: Double { Double(self) }
}

public enum AnimatedValue: Equatable {
    case number(any AnimatedNumericValue)
    case currency(any AnimatedNumericValue)
    
    public var amount: Double {
        switch self {
        case .number(let value), .currency(let value):
            value.animatedDoubleValue
        }
    }

    public static func == (lhs: AnimatedValue, rhs: AnimatedValue) -> Bool {
        switch (lhs, rhs) {
        case (.number, .number), (.currency, .currency):
            lhs.amount == rhs.amount
        default:
            false
        }
    }
}
