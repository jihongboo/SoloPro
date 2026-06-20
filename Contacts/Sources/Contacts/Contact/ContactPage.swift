import SwiftData
import SwiftUI

import Model
import Widgets

struct ContactPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var contact: Contact

    @State private var isPresentingEditForm = false
    
    init(_ contact: Contact) {
        self.contact = contact
    }

    var body: some View {
        List {
            Section {
                VStack {
                    AvatarView(contact, size: .large)

                    if !tags.isEmpty {
                        ContactTagRowView(tags: tags)
                    }
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
            .listSectionMargins(.top, 0)

            Section("Contact") {
                if let phone = contact.phone, !phone.isEmpty {
                    Label(phone, systemImage: "phone")
                }

                if let email = contact.email, !email.isEmpty {
                    Label(email, systemImage: "envelope")
                }

                if let address = contact.address, !address.isEmpty {
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
                LabeledContent("Customer Since", value: contact.createdAt.formatted(.dateTime.month(.abbreviated).day().year()))
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

            if let notes = contact.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section {
                Button(role: .destructive) {
                    modelContext.delete(contact)
                    dismiss()
                } label: {
                    Label("Delete Contact", systemImage: "trash")
                }
            }
        }
        .navigationTitle(contact.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isPresentingEditForm = true
                }
            }
        }
        .sheet(isPresented: $isPresentingEditForm) {
            ContactFormPage(mode: .edit(contact))
        }
    }
}

#Preview {
    NavigationStack {
        ContactPage(.mock)
    }
    .modelContainer(.mock)
}

private extension ContactPage {
    private var customerJobs: [Job] {
        contact.jobs ?? []
    }

    private var sortedJobs: [Job] {
        customerJobs.sorted { $0.date > $1.date }
    }

    private var completedJobs: [Job] {
        customerJobs.filter { $0.status == .completed }
    }

    private var lifetimeValue: Double {
        completedJobs.reduce(0) { $0 + $1.price }
    }

    private var hasContactDetails: Bool {
        contact.phone?.isEmpty == false ||
        contact.email?.isEmpty == false ||
        contact.address?.isEmpty == false
    }

    private var tags: [ContactTag] {
        ContactTag.tags(for: contact)
    }
}
