import SwiftData
import SwiftUI
import Model

struct JobFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Customer.name) private var customers: [Customer]

    let mode: JobFormMode

    @State private var title: String = ""
    @State private var customerName: String = ""
    @State private var date: Date = Date()
    @State private var address: String = ""
    @State private var priceText: String = ""
    @State private var notes: String = ""
    @State private var status: JobStatus = .scheduled

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Job") {
                    TextField("Job Title", text: $title)
                    TextField("Customer", text: $customerName)
                        .textContentType(.name)
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Location") {
                    TextField("Address", text: $address, axis: .vertical)
                        .textContentType(.fullStreetAddress)
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
        }
    }
}

#Preview("Create") {
    JobFormView(mode: .create)
        .modelContainer(.mock)
}

#Preview("Edit") {
    JobFormView(mode: .edit(.mock))
        .modelContainer(.mock)
}

private extension JobFormView {
    private func populateFields() {
        guard case let .edit(job) = mode, title.isEmpty else { return }

        title = job.title
        customerName = job.customer?.name ?? ""
        date = job.date
        address = job.address
        priceText = job.price == 0 ? "" : String(format: "%.2f", job.price)
        notes = job.notes ?? ""
        status = job.status
    }

    private func save() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCustomerName = customerName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let price = Double(priceText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        let customer: Customer

        if let existingCustomer = existingCustomer(named: cleanCustomerName) {
            customer = existingCustomer
        } else {
            customer = Customer(name: cleanCustomerName, address: cleanAddress.isEmpty ? nil : cleanAddress)
            modelContext.insert(customer)
        }

        switch mode {
        case .create:
            let job = Job(
                title: cleanTitle,
                date: date,
                address: cleanAddress,
                price: price,
                notes: cleanNotes.isEmpty ? nil : cleanNotes,
                status: status,
                customer: customer
            )
            modelContext.insert(job)
        case let .edit(job):
            job.title = cleanTitle
            job.date = date
            job.address = cleanAddress
            job.price = price
            job.notes = cleanNotes.isEmpty ? nil : cleanNotes
            job.status = status
            job.customer = customer
        }

        dismiss()
    }

    private func existingCustomer(named name: String) -> Customer? {
        customers.first { $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame }
    }
}
