//
//  File.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation

@MainActor
public extension Contact {
    static let mock = john
    
    static let john = Contact(
        name: "John Smith",
        phone: "+1 555 123 4567",
        address: "123 Main Street",
        latitude: 31.2356,
        longitude: 121.4747,
    )
    
    static let emma = Contact(
        name: "Emma Wilson",
        phone: "+1 555 987 6543",
        address: "48 Oak Avenue",
        latitude: 31.2306,
        longitude: 121.4707,
    )
    
    static let david = Contact(
        name: "David Brown",
        address: "700 Pine Road",
        latitude: 31.2396,
        longitude: 121.4797,
    )
}

@MainActor
public extension Array where Element == Contact {
    static let mock = [
        Contact.john,
        Contact.emma,
        Contact.david
    ]
}
