import SwiftUI
import Model

struct ContactTagRowView: View {
    let tags: [ContactTag]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 6) {
                ForEach(tags) { tag in
                    Label(tag.title, systemImage: tag.systemImage)
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tag.tint.opacity(0.15), in: Capsule())
                        .foregroundStyle(tag.tint)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }
}

#Preview {
    ContactTagRowView(tags: ContactTag.allCases)
        .padding()
}

enum ContactTag: String, CaseIterable, Identifiable {
    case vip
    case returning
    case referral
    case latePayment

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vip:
            "VIP"
        case .returning:
            "Returning"
        case .referral:
            "Referral"
        case .latePayment:
            "Late Payment"
        }
    }

    var systemImage: String {
        switch self {
        case .vip:
            "star.fill"
        case .returning:
            "arrow.clockwise"
        case .referral:
            "person.2"
        case .latePayment:
            "exclamationmark.circle"
        }
    }

    var tint: Color {
        switch self {
        case .vip:
            .yellow
        case .returning:
            .blue
        case .referral:
            .green
        case .latePayment:
            .red
        }
    }

    static func tags(for customer: Contact) -> [ContactTag] {
        var tags: [ContactTag] = []
        let jobs = customer.jobs ?? []
        let completedJobs = jobs.filter { $0.status == .completed }
        let lifetimeValue = completedJobs.reduce(0) { $0 + $1.price }
        let notes = customer.notes ?? ""

        if lifetimeValue >= 500 {
            tags.append(.vip)
        }

        if completedJobs.count >= 2 {
            tags.append(.returning)
        }

        if notes.localizedCaseInsensitiveContains("referral") ||
            notes.localizedCaseInsensitiveContains("referred") {
            tags.append(.referral)
        }

        if notes.localizedCaseInsensitiveContains("late payment") ||
            notes.localizedCaseInsensitiveContains("unpaid") {
            tags.append(.latePayment)
        }

        return tags
    }
}
