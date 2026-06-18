import SwiftData
import SwiftUI
import Model
import Widgets

struct JobFormPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Customer.name) private var customers: [Customer]

    let mode: JobFormMode

    @State private var title: String = ""
    @State private var customerName: String = ""
    @State private var selectedCustomer: Customer?
    @State private var isCreatingCustomer = false
    @State private var isPresentingCustomerList = false
    @State private var customerPhone: String = ""
    @State private var customerEmail: String = ""
    @State private var customerAddress: String = ""
    @State private var customerNotes: String = ""
    @State private var date: Date = Date()
    @State private var address: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var isPresentingLocationSearch = false
    @State private var priceText: String = ""
    @State private var notes: String = ""
    @State private var status: JobStatus = .scheduled
    @FocusState private var focusedField: JobFormField?

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
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

                JobCustomerSectionView(
                    customerName: $customerName,
                    isCreatingCustomer: $isCreatingCustomer,
                    customerPhone: $customerPhone,
                    customerEmail: $customerEmail,
                    customerAddress: $customerAddress,
                    customerNotes: $customerNotes,
                    customerSuggestions: customerSuggestions,
                    shouldShowCustomerSuggestions: shouldShowCustomerSuggestions,
                    focusedField: $focusedField,
                    onSelectCustomer: selectCustomer,
                    onCreateCustomer: startCreatingCustomer,
                    onChooseFromContacts: {
                        focusedField = nil
                        isPresentingCustomerList = true
                    }
                )

                Section("Location") {
                    JobLocationSectionView(
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
            .onChange(of: customerName) { _, newValue in
                updateCustomerSelection(for: newValue)
            }
            .sheet(isPresented: $isPresentingCustomerList) {
                CustomerSelectionSheet(
                    selectedCustomer: Binding(
                        get: { selectedCustomer },
                        set: { newCustomer in
                            guard let newCustomer else {
                                selectedCustomer = nil
                                return
                            }

                            selectCustomer(newCustomer)
                        }
                    )
                )
            }
        }
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

private extension JobFormPage {
    private var customerSuggestions: [Customer] {
        let cleanName = customerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return [] }

        return Array(customers.filter { customer in
            customer.name.localizedCaseInsensitiveContains(cleanName)
        }.prefix(5))
    }

    private var shouldShowCustomerSuggestions: Bool {
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCustomer == nil &&
        !isCreatingCustomer
    }

    private func populateFields() {
        guard case let .edit(job) = mode, title.isEmpty else { return }

        title = job.title
        customerName = job.customer?.name ?? ""
        selectedCustomer = job.customer
        date = job.date
        address = job.address
        latitude = job.latitude
        longitude = job.longitude
        priceText = job.price == 0 ? "" : String(format: "%.2f", job.price)
        notes = job.notes ?? ""
        status = job.status
    }

    private func selectCustomer(_ customer: Customer) {
        focusedField = nil
        selectedCustomer = customer
        isCreatingCustomer = false
        customerName = customer.name
        customerPhone = customer.phone ?? ""
        customerEmail = customer.email ?? ""
        customerAddress = customer.address ?? ""
        customerNotes = customer.notes ?? ""

        if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let customerAddress = customer.address {
            address = customerAddress
            latitude = customer.latitude
            longitude = customer.longitude
        }
    }

    private func startCreatingCustomer() {
        selectedCustomer = nil
        isCreatingCustomer = true

        if customerAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            customerAddress = address
        }
    }

    private func updateCustomerSelection(for name: String) {
        guard let selectedCustomer else { return }

        if selectedCustomer.name.localizedCaseInsensitiveCompare(name) != .orderedSame {
            self.selectedCustomer = nil
        }
    }

    private func save() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCustomerName = customerName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let price = Double(priceText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        guard let latitude, let longitude else { return }
        let customer = resolvedCustomer(named: cleanCustomerName, fallbackAddress: cleanAddress)

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
                customer: customer
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
            job.customer = customer
        }

        dismiss()
    }

    private func resolvedCustomer(named name: String, fallbackAddress: String) -> Customer {
        if let selectedCustomer,
           selectedCustomer.name.localizedCaseInsensitiveCompare(name) == .orderedSame {
            return selectedCustomer
        }

        if let existingCustomer = existingCustomer(named: name) {
            return existingCustomer
        }

        let cleanPhone = customerPhone.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = customerEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCustomerAddress = customerAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCustomerNotes = customerNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedAddress = cleanCustomerAddress.nilIfEmpty ?? fallbackAddress.nilIfEmpty
        let shouldUseJobCoordinates = resolvedAddress == fallbackAddress.nilIfEmpty
        let customer = Customer(
            name: name,
            phone: isCreatingCustomer ? cleanPhone.nilIfEmpty : nil,
            email: isCreatingCustomer ? cleanEmail.nilIfEmpty : nil,
            address: resolvedAddress,
            latitude: shouldUseJobCoordinates ? latitude : nil,
            longitude: shouldUseJobCoordinates ? longitude : nil,
            notes: isCreatingCustomer ? cleanCustomerNotes.nilIfEmpty : nil
        )
        modelContext.insert(customer)
        return customer
    }

    private func existingCustomer(named name: String) -> Customer? {
        customers.first { $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame }
    }
    
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
