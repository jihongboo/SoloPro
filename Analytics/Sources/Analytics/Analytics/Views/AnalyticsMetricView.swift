//
//  AnalyticsMetricView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Widgets

struct AnalyticsMetricView: View {
    let title: String
    let value: AnimatedValue
    let caption: String
    let systemImage: String
    let tint: Color
    
    @State private var displayedValue = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(tint)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            AnimatedNumber(value)
            
            Text(caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}



#Preview {
    @Previewable @State var number: Double = 1
    
    VStack {
        HStack {
            AnalyticsMetricView(
                title: "Income",
                value: .currency(number),
                caption: "Completed jobs",
                systemImage: "dollarsign.circle.fill",
                tint: .green
            )
            AnalyticsMetricView(
                title: "Number",
                value: .number(number),
                caption: "Completed jobs",
                systemImage: "number.sign.circle.fill",
                tint: .blue
            )
        }
        Button("Increment") {
            number = Double.random(in: 1..<100)
        }
    }
    .padding()
}
