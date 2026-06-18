//
//  AppIntent.swift
//  JoboryWidget
//
//  Created by 纪洪波 on 2026/6/15.
//

import WidgetKit
import AppIntents
import SwiftData
import Model

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

struct AdvanceJobStatusIntent: AppIntent {
    static var title: LocalizedStringResource { "Update Job Status" }
    static var description = IntentDescription("Moves a job to the next work status.")

    @Parameter(title: "Job ID")
    var jobID: String

    init() {}

    init(jobID: UUID) {
        self.jobID = jobID.uuidString
    }

    func perform() async throws -> some IntentResult {
        guard let id = UUID(uuidString: jobID) else {
            return .result()
        }

        let container = try ModelContainer.makeShared()
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<Job>()

        guard let job = try context.fetch(descriptor).first(where: { $0.id == id }) else {
            return .result()
        }

        job.status = nextStatus(after: job.status)
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()

        return .result()
    }

    private func nextStatus(after status: JobStatus) -> JobStatus {
        switch status {
        case .scheduled:
            .inProgress
        case .inProgress:
            .completed
        case .completed, .canceled:
            .scheduled
        }
    }
}
