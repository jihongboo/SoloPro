//
//  AnimatedNumber.swift
//  Widgets
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI

public struct AnimatedNumber: View {
    private let value: AnimatedValue
    
    @State private var displayedValue = 0.0
    
    public init(_ value: AnimatedValue) {
        self.value = value
    }
    
    public var body: some View {
        text
            .contentTransition(.numericText())
            .animation(.smooth, value: displayedValue)
            .onAppear {
                displayedValue = value.amount
            }
            .onChange(of: value) {
                displayedValue = value.amount
            }
    }
    
    private var text: Text {
        switch value {
        case .number:
            Text(displayedValue, format: .number.precision(.fractionLength(0)))
        case .currency:
            Text(displayedValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

#Preview {
    @Previewable @State var number: Double = 1
    VStack {
        AnimatedNumber(.currency(number))
        AnimatedNumber(.number(number))
        Button("Increment") {
            number = Double.random(in: 1..<100)
        }
    }
    .padding()
}
