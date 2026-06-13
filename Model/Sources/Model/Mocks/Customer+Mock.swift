//
//  File.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation

@MainActor
public extension Customer {
    static let mock = john
    
    static let john = Customer(
        name: "John Smith",
        phone: "+1 555 123 4567",
        address: "123 Main Street"
    )
    
    static let emma = Customer(
        name: "Emma Wilson",
        phone: "+1 555 987 6543",
        address: "48 Oak Avenue"
    )
    
    static let david = Customer(
        name: "David Brown",
        address: "700 Pine Road"
    )
}

@MainActor
public extension Array where Element == Customer {
    static let mock = [
        Customer.john,
        Customer.emma,
        Customer.david
    ]
}
