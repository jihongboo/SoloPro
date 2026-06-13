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
    
    @State private var animationProgress = 0.0
    
    private var visibleItems: [StatusAnalyticsItem] {
        items.filter { $0.count > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("Status Usage")
                    .font(.headline)
                
                Spacer()
                
                HStack {
                    Text(CGFloat(total) * animationProgress, format: .number)
                        .font(.headline)
                        .contentTransition(.numericText())
                    Text(total == 1 ? "job" : "jobs")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            StatusStorageBar(items: visibleItems, total: total, animationProgress: animationProgress)
                .frame(height: 18)
                .accessibilityLabel("Job status distribution")
            
            VStack(spacing: 10) {
                ForEach(items) { item in
                    StatusStorageLegendRow(
                        item: item,
                        total: total,
                        animationProgress: animationProgress
                    )
                }
            }
        }
        .padding(.vertical, 4)
        .onAppear(perform: animateBar)
        .onChange(of: items, animateBar)
        .onChange(of: total, animateBar)
    }
    
    private func animateBar() {
        animationProgress = 0
        
        withAnimation(.smooth) {
            animationProgress = 1
        }
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
    let animationProgress: Double
    
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
        return availableWidth * percentage * animationProgress
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
    let animationProgress: Double
    
    var body: some View {
        HStack {
            Circle()
                .fill(item.status.tint.gradient)
                .frame(width: 10, height: 10)
            
            Text(item.status.title)
                .font(.subheadline)
            
            Spacer()
            
            Text(
                Double(item.count) / Double(total) * animationProgress,
                format: .percent.precision(.fractionLength(0))
            )
            .font(.subheadline)
            .contentTransition(.numericText())
            .foregroundStyle(.secondary)
            
            Text(CGFloat(item.count) * animationProgress, format: .number)
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .contentTransition(.numericText())
                .frame(minWidth: 28, alignment: .trailing)
        }
    }
}
