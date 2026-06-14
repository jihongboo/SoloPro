import SwiftUI
import Model

struct StatusBadgeView: View {
    let status: JobStatus

    var body: some View {
        Text(status.title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(status.tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.tint.opacity(0.12), in: Capsule())
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
