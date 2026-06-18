//
//  StatusAnalyticsRowView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Model

struct StatusAnalyticsItem: Equatable, Identifiable {
    let status: JobStatus
    let count: Int
    
    var id: JobStatus { status }
}

struct StatusAnalyticsStorageView: View {
    let items: [StatusAnalyticsItem]
    let total: Int
    
    private var visibleItems: [StatusAnalyticsItem] {
        items.filter { $0.count > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            StatusStorageBar(items: visibleItems, total: total)
                .frame(height: 18)
                .accessibilityLabel("Job status distribution")
            
            VStack(spacing: 10) {
                ForEach(items) { item in
                    StatusStorageLegendRow(
                        item: item,
                        total: total
                    )
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        StatusAnalyticsStorageView(
            items: [
                .init(status: .scheduled, count: 3),
                .init(status: .inProgress, count: 5),
                .init(status: .completed, count: 8),
                .init(status: .canceled, count: 1)
            ],
            total: 17
        )
    }
}

private struct StatusStorageBar: View {
    let items: [StatusAnalyticsItem]
    let total: Int
    
    private let spacing = 2.0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.quaternary)
                
                if total > 0 {
                    HStack(spacing: spacing) {
                        ForEach(items) { item in
                            CapsuleSegment(color: item.status.tint)
                                .frame(width: segmentWidth(for: item, containerWidth: proxy.size.width))
                        }
                    }
                    .clipShape(.capsule)
                }
            }
        }
    }
    
    private func segmentWidth(for item: StatusAnalyticsItem, containerWidth: CGFloat) -> CGFloat {
        guard total > 0 else { return 0 }
        
        let spacingWidth = spacing * Double(max(items.count - 1, 0))
        let availableWidth = max(containerWidth - spacingWidth, 0)
        let percentage = Double(item.count) / Double(total)
        return availableWidth * percentage
    }
}

private struct CapsuleSegment: View {
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color.gradient)
    }
}

private struct StatusStorageLegendRow: View {
    let item: StatusAnalyticsItem
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(item.count) / Double(total)
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(item.status.tint.gradient)
                .frame(width: 10, height: 10)
            
            Text(item.status.title)
                .font(.subheadline)
            
            Spacer()
            
            Text(
                percentage,
                format: .percent.precision(.fractionLength(0))
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Text(item.count, format: .number)
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .frame(minWidth: 28, alignment: .trailing)
        }
    }
}
