//
//  CustomerSuggestionRow.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/13.
//

import SwiftUI
import Model

public struct CustomerSuggestionRow: View {
    let customer: Customer
    
    public init(customer: Customer) {
        self.customer = customer
    }

    public var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .foregroundStyle(.primary)

                if let detail = primaryDetail {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        } icon: {
            Image(systemName: "person.crop.circle")
        }
    }
}

#Preview {
    List {
        CustomerSuggestionRow(customer: .mock)
    }
}

private extension CustomerSuggestionRow {
    private var primaryDetail: String? {
        if let phone = customer.phone, !phone.isEmpty {
            phone
        } else if let email = customer.email, !email.isEmpty {
            email
        } else if let address = customer.address, !address.isEmpty {
            address
        } else {
            nil
        }
    }
}
