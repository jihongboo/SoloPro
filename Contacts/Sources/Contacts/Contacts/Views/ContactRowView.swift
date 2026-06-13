import SwiftUI
import Model

struct ContactRowView: View {
    let customer: Customer

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(customer.name)
                    .font(.headline)
                Spacer()
                Text(lifetimeValue, format: .currency(code: "USD"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if let primaryDetail {
                Label(primaryDetail.text, systemImage: primaryDetail.systemImage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if !tags.isEmpty {
                ContactTagRowView(tags: tags)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ContactRowView(customer: .mock)
    }
}

private extension ContactRowView {
    private var lifetimeValue: Double {
        customer.jobs
            .filter { $0.status == .completed }
            .reduce(0) { $0 + $1.price }
    }

    private var primaryDetail: ContactDetail? {
        if let phone = customer.phone, !phone.isEmpty {
            ContactDetail(text: phone, systemImage: "phone")
        } else if let email = customer.email, !email.isEmpty {
            ContactDetail(text: email, systemImage: "envelope")
        } else if let address = customer.address, !address.isEmpty {
            ContactDetail(text: address, systemImage: "mappin.and.ellipse")
        } else {
            nil
        }
    }

    private var tags: [ContactTag] {
        ContactTag.tags(for: customer)
    }
}

private struct ContactDetail {
    let text: String
    let systemImage: String
}
