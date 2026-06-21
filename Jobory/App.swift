import SwiftData
import SwiftUI
import Model

@main
struct SoloProApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
//        .modelContainer(.shared)
        .modelContainer(.mock)
    }
}

