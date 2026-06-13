import Model

enum ContactFormMode {
    case create
    case edit(Customer)

    var title: String {
        switch self {
        case .create:
            "Add Contact"
        case .edit:
            "Edit Contact"
        }
    }
}
