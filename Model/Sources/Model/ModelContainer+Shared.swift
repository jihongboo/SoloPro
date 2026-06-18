import SwiftData

public extension ModelContainer {
    static let appGroupIdentifier = "group.com.jihongbo.solopro"
    static let cloudKitContainerIdentifier = "iCloud.com.jihongbo.solopro"

    @MainActor
    static let shared: ModelContainer = {
        do {
            return try makeShared()
        } catch {
            fatalError("Failed to create shared model container: \(error)")
        }
    }()

    static func makeShared() throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: Schema([Customer.self, Job.self]),
            groupContainer: .identifier(appGroupIdentifier),
            cloudKitDatabase: .private(cloudKitContainerIdentifier)
        )

        return try ModelContainer(
            for: Customer.self,
            Job.self,
            configurations: configuration
        )
    }
}
