import SwiftData
import SwiftUI

import Model
import Widgets
import Contacts

struct JobFormPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let mode: JobFormPage.Mode

    @State private var title: String = ""
    @State private var customerName = ""
    @State private var contact: Contact?
    @State private var date: Date = Date()
    @State private var address: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var isPresentingLocationSearch = false
    @State private var priceText: String = ""
    @State private var notes: String = ""
    @State private var status: JobStatus = .scheduled
    @State private var isPresentingContacts = false

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        contact != nil &&
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        latitude != nil &&
        longitude != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Job") {
                    TextField("Job Title", text: $title)
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Customer") {
                    if let contact {
                        ContactView(contact)
                    }
                    
                    Button("Choose from Contacts", systemImage: "person.crop.circle") {
                        isPresentingContacts = true
                    }
                }

                Section("Location") {
                    LocationButton(
                        address: $address,
                        latitude: $latitude,
                        longitude: $longitude
                    )
                }

                Section("Payment") {
                    TextField("Price", text: $priceText)
                        .keyboardType(.decimalPad)
                }

                Section("Status") {
                    Picker("Status", selection: $status) {
                        ForEach(JobStatus.allCases) { status in
                            Text(status.title).tag(status)
                        }
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(!canSave)
                }
            }
            .onAppear(perform: populateFields)
            .onChange(of: contact) {
                guard let contact else { return }
                
                address = contact.address ?? ""
                latitude = contact.latitude
                longitude = contact.longitude
            }
            .sheet(isPresented: $isPresentingContacts) {
                ContactsPage(selection: $contact)
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview("Create") {
    JobFormPage(mode: .create)
        .modelContainer(.mock)
}

#Preview("Edit") {
    JobFormPage(mode: .edit(.mock))
        .modelContainer(.mock)
}

extension JobFormPage {
    enum Mode {
        case create
        case edit(Job)

        var title: String {
            switch self {
            case .create:
                "New Job"
            case .edit:
                "Edit Job"
            }
        }
    }

}

private extension JobFormPage {
    private func populateFields() {
        guard case let .edit(job) = mode, title.isEmpty else { return }

        title = job.title
        contact = job.customer
        date = job.date
        address = job.address
        latitude = job.latitude
        longitude = job.longitude
        priceText = job.price == 0 ? "" : String(format: "%.2f", job.price)
        notes = job.notes ?? ""
        status = job.status
    }

    private func save() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let price = Double(priceText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        guard let latitude, let longitude, let contact else { return }

        switch mode {
        case .create:
            let job = Job(
                title: cleanTitle,
                date: date,
                address: cleanAddress,
                latitude: latitude,
                longitude: longitude,
                price: price,
                notes: cleanNotes.nilIfEmpty,
                status: status,
                customer: contact
            )
            modelContext.insert(job)
        case let .edit(job):
            job.title = cleanTitle
            job.date = date
            job.address = cleanAddress
            job.latitude = latitude
            job.longitude = longitude
            job.price = price
            job.notes = cleanNotes.nilIfEmpty
            job.status = status
            job.customer = contact
        }

        dismiss()
    }

}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
