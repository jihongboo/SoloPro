import SwiftData
import SwiftUI
import Model
import Widgets

struct ContactFormPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let mode: ContactFormMode

    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var address = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var notes = ""
    @State private var isPresentingLocationSearch = false

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
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
                    Button {
                        isPresentingLocationSearch = true
                    } label: {
                        HStack {
                            Label {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(address.isEmpty ? "Add Location" : "Location")

                                    if !address.isEmpty {
                                        Text(address)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                            } icon: {
                                Image(systemName: "mappin.and.ellipse")
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .foregroundStyle(.primary)
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
            .sheet(isPresented: $isPresentingLocationSearch) {
                LocationSearchPage(
                    address: $address,
                    latitude: $latitude,
                    longitude: $longitude
                )
            }
        }
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

private extension ContactFormPage {
    private func populateFields() {
        guard case let .edit(customer) = mode, name.isEmpty else { return }

        name = customer.name
        phone = customer.phone ?? ""
        email = customer.email ?? ""
        address = customer.address ?? ""
        latitude = customer.latitude
        longitude = customer.longitude
        notes = customer.notes ?? ""
    }

    private func save() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        switch mode {
        case .create:
            let customer = Customer(
                name: cleanName,
                phone: cleanPhone.nilIfEmpty,
                email: cleanEmail.nilIfEmpty,
                address: cleanAddress.nilIfEmpty,
                latitude: cleanAddress.isEmpty ? nil : latitude,
                longitude: cleanAddress.isEmpty ? nil : longitude,
                notes: cleanNotes.nilIfEmpty
            )
            modelContext.insert(customer)
        case let .edit(customer):
            customer.name = cleanName
            customer.phone = cleanPhone.nilIfEmpty
            customer.email = cleanEmail.nilIfEmpty
            customer.address = cleanAddress.nilIfEmpty
            customer.latitude = cleanAddress.isEmpty ? nil : latitude
            customer.longitude = cleanAddress.isEmpty ? nil : longitude
            customer.notes = cleanNotes.nilIfEmpty
        }

        dismiss()
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
