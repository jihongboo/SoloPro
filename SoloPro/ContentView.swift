import SwiftData
import SwiftUI
import Analytics
import Contacts
import Job
import Model

@main
struct SoloProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Customer.self, Job.self])
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TodayJobsPage()
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }

            NavigationStack {
                ContactsPage()
            }
            .tabItem {
                Label("Contacts", systemImage: "person.2")
            }

            NavigationStack {
                AnalyticsPage()
            }
            .tabItem {
                Label("Analytics", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(.mock)
}
