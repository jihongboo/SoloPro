//
//  CustomerSelectionSheet.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Model

public struct CustomerSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

    let customers: [Customer]
    @Binding var selectedCustomer: Customer?

    @State private var searchText = ""
    
    public init(
        customers: [Customer],
        selectedCustomer: Binding<Customer?>,
    ) {
        self.customers = customers
        _selectedCustomer = selectedCustomer
    }

    public var body: some View {
        NavigationStack {
            List {
                if filteredCustomers.isEmpty {
                    ContentUnavailableView(
                        "No Customers Found",
                        systemImage: "person.crop.circle.badge.questionmark",
                        description: Text("Try searching by name, phone, email, or address.")
                    )
                } else {
                    ForEach(filteredCustomers) { customer in
                        Button {
                            selectedCustomer = customer
                            dismiss()
                        } label: {
                            CustomerSuggestionRow(customer: customer)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Choose Customer")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search Contacts")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var filteredCustomers: [Customer] {
        let cleanSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanSearchText.isEmpty else { return customers }

        return customers.filter { customer in
            customer.name.localizedCaseInsensitiveContains(cleanSearchText) ||
            customer.phone?.localizedCaseInsensitiveContains(cleanSearchText) == true ||
            customer.email?.localizedCaseInsensitiveContains(cleanSearchText) == true ||
            customer.address?.localizedCaseInsensitiveContains(cleanSearchText) == true
        }
    }
}

#Preview {
    @Previewable @State var selectedCustomer: Customer? = nil
    CustomerSelectionSheet(
        customers: .mock,
        selectedCustomer: $selectedCustomer
    )
}
