import SwiftData

@MainActor
public extension ModelContainer {
    static let mock: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Customer.self, Job.self, configurations: configuration)

        [Job].mock.forEach(container.mainContext.insert)
        [Customer].mock.forEach(container.mainContext.insert)
        return container
    }()
}
