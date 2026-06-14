//
//  RecentIncomeCell.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Model

struct RecentIncomeCell: View {
    let job: Job

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.headline)
                Text(job.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(job.price.formatted(.currency(code: "USD")))
                .font(.headline)
        }
    }
}

#Preview {
    List {
        RecentIncomeCell(
            job: Job(
                title: "Kitchen Repair",
                date: .now,
                address: "123 Main Street",
                latitude: 31.2356,
                longitude: 121.4747,
                price: 240,
                status: .completed
            )
        )
    }
}
