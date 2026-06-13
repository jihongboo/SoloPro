import SwiftData
import SwiftUI
import Model
import Widgets

public struct ContactsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Customer.name) private var customers: [Customer]

    @State private var searchText = ""
    @State private var isPresentingCustomerForm = false
    @Namespace private var addContactTransition

    private let addContactSourceID = "add-contact-button"

    public init() {}

    public var body: some View {
        List {
            Section(listSectionTitle) {
                if filteredCustomers.isEmpty {
                    ContentUnavailableView(
                        emptyStateTitle,
                        systemImage: "person.crop.circle.badge.questionmark",
                        description: Text(emptyStateDescription)
                    )
                } else {
                    ForEach(filteredCustomers) { customer in
                        NavigationLink(value: customer) {
                            CustomerSuggestionRow(customer: customer)
                        }
                    }
                    .onDelete(perform: deleteCustomers)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Contacts")
        .searchable(text: $searchText, prompt: "Search Contacts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingCustomerForm = true
                } label: {
                    Label("Add Contact", systemImage: "plus")
                }
            }
            .matchedTransitionSource(id: addContactSourceID, in: addContactTransition)
        }
        .navigationDestination(for: Customer.self) { customer in
            ContactPage(customer: customer)
        }
        .sheet(isPresented: $isPresentingCustomerForm) {
            ContactFormPage(mode: .create)
                .navigationTransition(.zoom(sourceID: addContactSourceID, in: addContactTransition))
        }
    }
}

#Preview {
    NavigationStack {
        ContactsPage()
    }
    .modelContainer(.mock)
}

private extension ContactsPage {
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

    private var listSectionTitle: String {
        "\(filteredCustomers.count) Customers"
    }

    private var emptyStateTitle: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "No Contacts" : "No Contacts Found"
    }

    private var emptyStateDescription: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
        "Add your first customer to keep jobs, notes, and contact details together." :
        "Try searching by name, phone, email, or address."
    }

    private func deleteCustomers(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredCustomers[index])
        }
    }
}
