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
        HStack(spacing: 14) {
            avatar

            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let detail = primaryDetail {
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
        CustomerSuggestionRow(customer: .mock)
    }
}

private extension CustomerSuggestionRow {
    private var avatar: some View {
        Text(initials)
            .font(.headline.weight(.semibold))
            .foregroundStyle(avatarColor)
            .frame(width: 48, height: 48)
            .background(avatarColor.opacity(0.16), in: Circle())
    }

    private var initials: String {
        let characters = customer.name
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)

        let value = String(characters).uppercased()
        return value.isEmpty ? "?" : value
    }

    private var avatarColor: Color {
        avatarColors[avatarColorIndex]
    }

    private var avatarColorIndex: Int {
        let value = customer.name.unicodeScalars.reduce(0) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }

        return value % avatarColors.count
    }

    private var avatarColors: [Color] {
        [.purple, .green, .orange, .teal, .pink, .blue]
    }

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
