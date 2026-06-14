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
            if filteredCustomers.isEmpty {
                Section(listSectionTitle) {
                    ContentUnavailableView(
                        emptyStateTitle,
                        systemImage: "person.crop.circle.badge.questionmark",
                        description: Text(emptyStateDescription)
                    )
                }
            } else {
                ForEach(customerSections) { section in
                    Section(section.title) {
                        ForEach(section.customers) { customer in
                            NavigationLink(value: customer) {
                                CustomerSuggestionRow(customer: customer)
                            }
                        }
                        .onDelete { offsets in
                            deleteCustomers(in: section, at: offsets)
                        }
                    }
                    .sectionIndexLabel(Text(section.indexLabel))
                }
            }
        }
        .listStyle(.plain)
        .listSectionIndexVisibility(.visible)
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

    private var customerSections: [CustomerSection] {
        let groupedCustomers = Dictionary(grouping: filteredCustomers, by: sectionTitle(for:))

        return groupedCustomers
            .map { CustomerSection(title: $0.key, customers: $0.value) }
            .sorted { lhs, rhs in
                if lhs.title == "#" { return false }
                if rhs.title == "#" { return true }
                return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
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

    private func sectionTitle(for customer: Customer) -> String {
        let trimmedName = customer.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmedName.first else { return "#" }

        return String(firstCharacter).uppercased()
    }

    private func deleteCustomers(in section: CustomerSection, at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(section.customers[index])
        }
    }
}

private struct CustomerSection: Identifiable {
    let title: String
    let customers: [Customer]

    var id: String { title }
    var indexLabel: String { title }
}
