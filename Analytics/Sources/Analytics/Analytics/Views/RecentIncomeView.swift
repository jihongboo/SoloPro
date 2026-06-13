//
//  RecentIncomeView.swift
//  Analytics
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Model

struct RecentIncomeView: View {
    let jobs: [Job]

    var body: some View {
        if jobs.isEmpty {
            ContentUnavailableView(
                "No Recent Income",
                systemImage: "tray",
                description: Text("Finished jobs with a price will appear here.")
            )
        } else {
            ForEach(jobs) { job in
                RecentIncomeCell(job: job)
            }
        }
    }
}

#Preview {
    List {
        Section("Recent Income") {
            RecentIncomeView(
                jobs: .mock
            )
        }

        Section("Recent Income") {
            RecentIncomeView(jobs: [])
        }
    }
}
