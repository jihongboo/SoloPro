import SwiftUI
import Model
import Widgets

struct JobCustomerSectionView: View {
    @Binding var customerName: String
    @Binding var isCreatingCustomer: Bool
    @Binding var customerPhone: String
    @Binding var customerEmail: String
    @Binding var customerAddress: String
    @Binding var customerNotes: String

    let customerSuggestions: [Customer]
    let shouldShowCustomerSuggestions: Bool
    let focusedField: FocusState<JobFormField?>.Binding
    let onSelectCustomer: (Customer) -> Void
    let onCreateCustomer: () -> Void
    let onChooseFromContacts: () -> Void

    var body: some View {
        Section("Customer") {
            TextField("Customer Name", text: $customerName)
                .textContentType(.name)
                .focused(focusedField, equals: .customerName)

            if shouldShowCustomerSuggestions {
                ForEach(customerSuggestions) { customer in
                    Button {
                        onSelectCustomer(customer)
                    } label: {
                        CustomerSuggestionRow(customer: customer)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    onCreateCustomer()
                } label: {
                    Label("Create New Customer", systemImage: "plus.circle")
                }
            }

            if isCreatingCustomer {
                TextField("Phone", text: $customerPhone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                TextField("Email", text: $customerEmail)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                TextField("Customer Address", text: $customerAddress, axis: .vertical)
                    .textContentType(.fullStreetAddress)
                TextField("Customer Notes", text: $customerNotes, axis: .vertical)
                    .lineLimit(2...4)
            }

            Button {
                onChooseFromContacts()
            } label: {
                Label("Choose from Contacts", systemImage: "person.crop.circle")
            }
        }
    }
}
