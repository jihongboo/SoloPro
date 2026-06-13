import SwiftUI
import Model

struct StatusBadgeView: View {
    let status: JobStatus

    var body: some View {
        Label(status.title, systemImage: status.systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(status.tint)
            .labelStyle(.titleAndIcon)
            .labelIconToTitleSpacing(2)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(JobStatus.allCases) { status in
            StatusBadgeView(status: status)
        }
    }
    .padding()
}
