import SwiftUI

struct SummaryMetricView: View {
    let title: String
    let value: String
    let caption: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HStack(spacing: 12) {
        SummaryMetricView(title: "Today", value: "3", caption: "Jobs")
        SummaryMetricView(title: "Expected", value: "$375.00", caption: "Income")
    }
    .padding()
}
