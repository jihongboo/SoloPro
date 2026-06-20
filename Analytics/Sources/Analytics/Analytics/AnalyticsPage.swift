import SwiftData
import SwiftUI
import Model

public struct AnalyticsPage: View {
    @State private var selectedDimension: AnalyticsTimeDimension = .month
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            AnalyticsView(dimension: selectedDimension)
                .navigationTitle("Analytics")
                .toolbar {
                    Picker(
                        "Time Dimension",
                        systemImage: "calendar",
                        selection: $selectedDimension
                    ) {
                        ForEach(AnalyticsTimeDimension.allCases) { dimension in
                            Text(dimension.title).tag(dimension)
                        }
                    }
                    .labelsHidden()
                    .fixedSize()
                }
        }
    }
}

#Preview {
    AnalyticsPage()
        .modelContainer(.mock)
}

#Preview("Empty") {
    AnalyticsPage()
}
