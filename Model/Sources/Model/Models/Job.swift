//
//  Job.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation
import SwiftData

@Model
public final class Job {
    #Index<Job>([\.date], [\.statusRawValue, \.date], [\.id], [\.title], [\.address])

    public var id: UUID = UUID()
    public var title: String = ""
    public var date: Date = Date()
    public var address: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var price: Double = 0
    public var notes: String?
    public var createdAt: Date = Date()
    public var customer: Contact?
    
    public var statusRawValue: Int = JobStatus.scheduled.rawValue
    public var status: JobStatus {
        get {
            JobStatus(rawValue: statusRawValue) ?? .scheduled
        }
        set {
            statusRawValue = newValue.rawValue
        }
    }

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

    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        address: String,
        latitude: Double,
        longitude: Double,
        price: Double = 0,
        notes: String? = nil,
        status: JobStatus = .scheduled,
        createdAt: Date = Date(),
        customer: Contact? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.notes = notes
        self.statusRawValue = status.rawValue
        self.createdAt = createdAt
        self.customer = customer
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        location: Location,
        price: Double = 0,
        notes: String? = nil,
        status: JobStatus = .scheduled,
        createdAt: Date = Date(),
        customer: Contact? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.price = price
        self.notes = notes
        self.statusRawValue = status.rawValue
        self.createdAt = createdAt
        self.customer = customer
    }
}
