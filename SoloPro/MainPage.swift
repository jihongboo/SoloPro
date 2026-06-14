//
//  ContentView 2.swift
//  SoloPro
//
//  Created by 纪洪波 on 2026/6/14.
//

import SwiftUI
import SwiftData

import Analytics
import Contacts
import Job
import Model
import AppFoundation

struct MainPage: View {
    @AppStorage("didSeedSampleJobs") private var didSeedSampleJobs = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab("Today", systemImage: "calendar") {
                NavigationStack {
                    TodayJobsPage()
                }
            }
            
            Tab("Contacts", systemImage: "person.2") {
                NavigationStack {
                    ContactsPage()
                }
            }
            
            Tab("Analytics", systemImage: "chart.line.uptrend.xyaxis") {
                NavigationStack {
                    AnalyticsPage()
                }
            }
        }
        .task(seedSampleJobsIfNeeded)
    }
}

#Preview {
    MainPage()
        .modelContainer(.mock)
}

private extension MainPage {
    func seedSampleJobsIfNeeded() {
        guard !isPreview, !didSeedSampleJobs else { return }
        [Job].mock.forEach(modelContext.insert)
        [Customer].mock.forEach(modelContext.insert)
        didSeedSampleJobs = true
    }
}
