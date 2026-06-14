import SwiftUI
import Model

struct JobRowView: View {
    let job: Job

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 2) {
                Text(job.date, format: .dateTime.hour().minute())
                    .font(.headline)
                Text(job.date, format: .dateTime.month(.abbreviated).day())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 56, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                Text(job.title)
                    .font(.headline)
                Text(job.customer?.name ?? "No Customer")
                    .font(.subheadline)
                if !job.address.isEmpty {
                    Label(job.address, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .labelIconToTitleSpacing(2)
                }
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 8) {
                Text(job.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                    .font(.subheadline.weight(.semibold))
                StatusBadgeView(status: job.status)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        JobRowView(job: .mock)
    }
}
