import SwiftData
import SwiftUI
import Model
import Widgets

public struct ContactsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Contact.name) private var contacts: [Contact]
    
    private let state: Model
    @Binding private var selection: Contact?
    @State private var searchText = ""
    @State private var isPresentingContactForm = false
    
    @Namespace private var addContactTransition
    private let addContactSourceID = "add-contact-button"
    
    public init(selection: Binding<Contact?>) {
        _selection = selection
        state = .selection
    }
    
    public init() {
        _selection = .constant(nil)
        state = .root
    }
    
    public var body: some View {
        List {
            ForEach(contactSections) { section in
                Section(section.title) {
                    ForEach(section.contacts) { contact in
                        switch state {
                        case .root:
                            NavigationLink(value: contact) {
                                ContactView(contact)
                            }
                        case .selection:
                            Button {
                                selection = contact
                                dismiss()
                            } label: {
                                ContactView(contact)
                            }
                        }
                    }
                    .onDelete { offsets in
                        deleteContacts(in: section, at: offsets)
                    }
                }
                .sectionIndexLabel(Text(section.indexLabel))
            }
        }
        .listStyle(.plain)
        .listSectionIndexVisibility(.visible)
        .overlay {
            if filteredContacts.isEmpty {
                ContentUnavailableView {
                    Label(emptyStateTitle, systemImage: "person.crop.circle.badge.questionmark")
                } description: {
                    Text(emptyStateDescription)
                } actions: {
                    if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button("Add Contact", systemImage: "plus") {
                            isPresentingContactForm = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
            }
        }
        .navigationTitle("Contacts")
        .searchable(text: $searchText, prompt: "Search Contacts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Contact", systemImage: "plus") {
                    isPresentingContactForm = true
                }
            }
            .matchedTransitionSource(id: addContactSourceID, in: addContactTransition)
        }
        .navigationDestination(for: Contact.self) { contact in
            ContactPage(contact)
        }
        .sheet(isPresented: $isPresentingContactForm) {
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

#Preview("Empty") {
    NavigationStack {
        ContactsPage()
    }
}

public extension ContactsPage {
    enum Model {
        case root
        case selection
    }
}

private extension ContactsPage {
    private var filteredContacts: [Contact] {
        let cleanSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanSearchText.isEmpty else { return contacts }
        
        return contacts.filter { contacts in
            contacts.name.localizedCaseInsensitiveContains(cleanSearchText) ||
            contacts.phone?.localizedCaseInsensitiveContains(cleanSearchText) == true ||
            contacts.email?.localizedCaseInsensitiveContains(cleanSearchText) == true ||
            contacts.address?.localizedCaseInsensitiveContains(cleanSearchText) == true
        }
    }
    
    private var contactSections: [ContactSection] {
        let groupedContacts = Dictionary(
            grouping: filteredContacts,
            by: sectionTitle(for:)
        )
        
        return groupedContacts
            .map { ContactSection(title: $0.key, contacts: $0.value) }
            .sorted { lhs, rhs in
                if lhs.title == "#" { return false }
                if rhs.title == "#" { return true }
                return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
            }
    }
    
    private var listSectionTitle: String {
        "\(filteredContacts.count) Customers"
    }
    
    private var emptyStateTitle: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "No Contacts" : "No Contacts Found"
    }
    
    private var emptyStateDescription: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
        "Add your first customer to keep jobs, notes, and contact details together." :
        "Try searching by name, phone, email, or address."
    }
    
    private func sectionTitle(for contact: Contact) -> String {
        let trimmedName = contact.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmedName.first else { return "#" }
        
        return String(firstCharacter).uppercased()
    }
    
    private func deleteContacts(in section: ContactSection, at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(section.contacts[index])
        }
    }
}

private struct ContactSection: Identifiable {
    let title: String
    let contacts: [Contact]
    
    var id: String { title }
    var indexLabel: String { title }
}
