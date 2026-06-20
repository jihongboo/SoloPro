import SwiftData
import SwiftUI

import Model
import Widgets

public struct ContactFormPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let mode: ContactFormPage.Mode
    @Binding var contact: Contact?

    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var location: Location?
    @State private var notes = ""

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        location != nil
    }
    
    public init(mode: ContactFormPage.Mode) {
        self.init(mode: mode, customer: .constant(nil))
    }

    public init(mode: ContactFormPage.Mode, customer: Binding<Contact?>) {
        self.mode = mode
        _contact = customer
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Customer") {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                    TextField("Phone", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section("Location") {
                    LocationButton(location: $location)
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
        }
        .interactiveDismissDisabled()
    }
}

#Preview("Create") {
    ContactFormPage(mode: .create)
        .modelContainer(.mock)
}

#Preview("Edit") {
    ContactFormPage(mode: .edit(.mock))
        .modelContainer(.mock)
}

public extension ContactFormPage {
    enum Mode {
        case create
        case edit(Contact)

        var title: String {
            switch self {
            case .create:
                "Add Contact"
            case .edit:
                "Edit Contact"
            }
        }
    }
}

private extension ContactFormPage {
    private func populateFields() {
        guard case let .edit(customer) = mode, name.isEmpty else { return }

        name = customer.name
        phone = customer.phone ?? ""
        email = customer.email ?? ""
        location = customer.location
        notes = customer.notes ?? ""
    }

    private func save() {
        guard let location else { return }
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        switch mode {
        case .create:
            let customer = Contact(
                name: cleanName,
                phone: cleanPhone.nilIfEmpty,
                email: cleanEmail.nilIfEmpty,
                location: location,
                notes: cleanNotes.nilIfEmpty
            )
            modelContext.insert(customer)
            self.contact = customer
        case let .edit(customer):
            customer.name = cleanName
            customer.phone = cleanPhone.nilIfEmpty
            customer.email = cleanEmail.nilIfEmpty
            customer.location = location
            customer.notes = cleanNotes.nilIfEmpty
            self.contact = customer
        }

        dismiss()
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
