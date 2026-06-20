import Foundation
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
                    contactLink(phone, systemImage: "phone", destination: phoneURL(for: phone))
                }

                if let email = contact.email, !email.isEmpty {
                    contactLink(email, systemImage: "envelope", destination: emailURL(for: email))
                }

                if let address = contact.address, !address.isEmpty {
                    contactLink(address, systemImage: "mappin.and.ellipse", destination: mapURL(for: address))
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

    @ViewBuilder
    private func contactLink(_ title: String, systemImage: String, destination: URL?) -> some View {
        if let destination {
            Link(destination: destination) {
                Label(title, systemImage: systemImage)
            }
        } else {
            Label(title, systemImage: systemImage)
        }
    }

    private func phoneURL(for phone: String) -> URL? {
        let dialableCharacters = CharacterSet(charactersIn: "+*#0123456789,;")
        let dialablePhone = phone.unicodeScalars.filter { dialableCharacters.contains($0) }
        return URL(string: "tel:\(String(String.UnicodeScalarView(dialablePhone)))")
    }

    private func emailURL(for email: String) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        return components.url
    }

    private func mapURL(for address: String) -> URL? {
        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [URLQueryItem(name: "q", value: address)]
        return components?.url
    }
}
