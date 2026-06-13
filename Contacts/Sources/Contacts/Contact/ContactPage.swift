import SwiftData
import SwiftUI
import Model

struct ContactPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var customer: Customer

    @State private var isPresentingEditForm = false

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text(customer.name)
                        .font(.title2.bold())

                    if !tags.isEmpty {
                        ContactTagRowView(tags: tags)
                    }
                }
                .padding(.vertical, 6)
            }

            Section("Contact") {
                if let phone = customer.phone, !phone.isEmpty {
                    Label(phone, systemImage: "phone")
                }

                if let email = customer.email, !email.isEmpty {
                    Label(email, systemImage: "envelope")
                }

                if let address = customer.address, !address.isEmpty {
                    Label(address, systemImage: "mappin.and.ellipse")
                }

                if !hasContactDetails {
                    Text("No contact details yet.")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Summary") {
                LabeledContent("Completed Jobs", value: completedJobs.count.formatted())
                LabeledContent("Lifetime Spend", value: lifetimeValue.formatted(.currency(code: "USD")))
                LabeledContent("Customer Since", value: customer.createdAt.formatted(.dateTime.month(.abbreviated).day().year()))
            }

            if !sortedJobs.isEmpty {
                Section("Job History") {
                    ForEach(sortedJobs) { job in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(job.title)
                                    .font(.headline)
                                Spacer()
                                Text(job.price, format: .currency(code: "USD"))
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }

                            Text(job.date, format: .dateTime.month(.abbreviated).day().year().hour().minute())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            if let notes = customer.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section {
                Button(role: .destructive) {
                    modelContext.delete(customer)
                    dismiss()
                } label: {
                    Label("Delete Contact", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Contact Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isPresentingEditForm = true
                }
            }
        }
        .sheet(isPresented: $isPresentingEditForm) {
            ContactFormPage(mode: .edit(customer))
        }
    }
}

#Preview {
    NavigationStack {
        ContactPage(customer: .mock)
    }
    .modelContainer(.mock)
}

private extension ContactPage {
    private var sortedJobs: [Job] {
        customer.jobs.sorted { $0.date > $1.date }
    }

    private var completedJobs: [Job] {
        customer.jobs.filter { $0.status == .completed }
    }

    private var lifetimeValue: Double {
        completedJobs.reduce(0) { $0 + $1.price }
    }

    private var hasContactDetails: Bool {
        customer.phone?.isEmpty == false ||
        customer.email?.isEmpty == false ||
        customer.address?.isEmpty == false
    }

    private var tags: [ContactTag] {
        ContactTag.tags(for: customer)
    }
}
