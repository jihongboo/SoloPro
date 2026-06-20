//
//  CustomerSuggestionRow.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI

import Model

public struct ContactView: View {
    let contact: Contact
    
    public init(_ contact: Contact) {
        self.contact = contact
    }

    public var body: some View {
        HStack(spacing: 14) {
            AvatarView(contact)

            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let detail {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ContactView(.mock)
    }
}

private extension ContactView {
    private var detail: String? {
        if let phone = contact.phone, !phone.isEmpty {
            phone
        } else if let email = contact.email, !email.isEmpty {
            email
        } else if let address = contact.address, !address.isEmpty {
            address
        } else {
            nil
        }
    }
}
