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
    public var id: UUID = UUID()
    public var title: String = ""
    public var date: Date = Date()
    public var address: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var price: Double = 0
    public var notes: String?
    public var status: JobStatus = JobStatus.scheduled
    public var createdAt: Date = Date()
    public var customer: Customer?

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
        customer: Customer? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.notes = notes
        self.status = status
        self.createdAt = createdAt
        self.customer = customer
    }
}
