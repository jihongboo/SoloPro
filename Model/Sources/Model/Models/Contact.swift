//
//  Customer.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation
import SwiftData

@Model
public final class Contact {
    public var id: UUID = UUID()
    public var name: String = ""
    public var phone: String?
    public var email: String?
    public var address: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var notes: String?
    public var createdAt: Date = Date()
    
    public var location: Location {
        get {
            .init(address: address, latitude: latitude, longitude: longitude)
        }
        set {
            address = newValue.address
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }

    @Relationship(deleteRule: .cascade, inverse: \Job.customer)
    public var jobs: [Job]?

    public init(
        id: UUID = UUID(),
        name: String,
        phone: String? = nil,
        email: String? = nil,
        address: String,
        latitude: Double,
        longitude: Double,
        notes: String? = nil,
        createdAt: Date = Date(),
        jobs: [Job] = []
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes
        self.createdAt = createdAt
        self.jobs = jobs
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        phone: String? = nil,
        email: String? = nil,
        location: Location,
        notes: String? = nil,
        createdAt: Date = Date(),
        jobs: [Job] = []
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.location = location
        self.notes = notes
        self.createdAt = createdAt
        self.jobs = jobs
    }
}
