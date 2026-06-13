//
//  StatusAnalyticsRowView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Model

struct StatusAnalyticsItem: Identifiable {
    let status: JobStatus
    let count: Int

    var id: JobStatus { status }
}

struct StatusAnalyticsRowView: View {
    let item: StatusAnalyticsItem
    let total: Int

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(item.count) / Double(total)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: item.status.systemImage)
                    .foregroundStyle(item.status.tint)
                    .frame(width: 24)

                Text(item.status.title)
                    .font(.headline)

                Spacer()

                Text("\(item.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(item.status.tint)
        }
        .padding(.vertical, 4)
    }
}
