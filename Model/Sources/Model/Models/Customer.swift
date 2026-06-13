//
//  Customer.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation
import SwiftData

@Model
public final class Customer {
    public var id: UUID
    public var name: String
    public var phone: String?
    public var email: String?
    public var address: String?
    public var notes: String?
    public var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Job.customer)
    public var jobs: [Job]

    public init(
        id: UUID = UUID(),
        name: String,
        phone: String? = nil,
        email: String? = nil,
        address: String? = nil,
        notes: String? = nil,
        createdAt: Date = Date(),
        jobs: [Job] = []
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.address = address
        self.notes = notes
        self.createdAt = createdAt
        self.jobs = jobs
    }
}
