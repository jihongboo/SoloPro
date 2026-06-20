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
        address: "123 Main Street"
    )
    
    static let emma = Contact(
        name: "Emma Wilson",
        phone: "+1 555 987 6543",
        address: "48 Oak Avenue"
    )
    
    static let david = Contact(
        name: "David Brown",
        address: "700 Pine Road"
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
