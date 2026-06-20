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
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab("Today", systemImage: "calendar") {
                TodayJobsPage()
            }
            
            Tab("Contacts", systemImage: "person.2") {
                ContactsPage()
            }
            
            Tab("Analytics", systemImage: "chart.line.uptrend.xyaxis") {
                AnalyticsPage()
            }
        }
    }
}

#Preview {
    MainPage()
        .modelContainer(.mock)
}
