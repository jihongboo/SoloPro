import SwiftData
import SwiftUI

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


struct MockPreviewModifier: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        .mock
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewModifier where Self == MockPreviewModifier {
    static var mock: MockPreviewModifier {
        MockPreviewModifier()
    }
}

public extension PreviewTrait where T == Preview.ViewTraits {
    static var mock: Self {
        .modifier(.mock)
    }
}
