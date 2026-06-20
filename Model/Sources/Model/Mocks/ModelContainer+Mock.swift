import SwiftData

@MainActor
public extension ModelContainer {
    static let mock: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Contact.self, Job.self, configurations: configuration)

        [Job].mock.forEach(container.mainContext.insert)
        [Contact].mock.forEach(container.mainContext.insert)
        return container
    }()
}
