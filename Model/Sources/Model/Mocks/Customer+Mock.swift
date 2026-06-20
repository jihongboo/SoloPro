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
        phone: "+1 212 555 0142",
        email: "john.smith@example.com",
        address: "350 5th Avenue, New York, NY",
        latitude: 40.7484,
        longitude: -73.9857,
        notes: "Prefers weekday morning appointments. Ask building security for elevator access.",
    )
    
    static let emma = Contact(
        name: "Emma Wilson",
        phone: "+1 646 555 0198",
        address: "200 Central Park West, New York, NY",
        latitude: 40.7813,
        longitude: -73.9735,
    )
    
    static let david = Contact(
        name: "David Brown",
        email: "david.brown@example.com",
        address: "11 Wall Street, New York, NY",
        latitude: 40.7074,
        longitude: -74.0113,
        notes: "Email before visiting. Usually unavailable during lunch hours.",
    )
    
    static let sophia = Contact(
        name: "Sophia Martinez",
        phone: "+1 917 555 0136",
        email: "sophia.martinez@example.com",
        address: "30 Rockefeller Plaza, New York, NY",
        latitude: 40.7587,
        longitude: -73.9787,
        notes: "Repeat customer. Confirm estimate details before starting work.",
    )
    
    static let liam = Contact(
        name: "Liam Johnson",
        address: "405 Lexington Avenue, New York, NY",
        latitude: 40.7517,
        longitude: -73.9753,
    )
    
    static let olivia = Contact(
        name: "Olivia Davis",
        email: "olivia.davis@example.com",
        address: "89 South Street, New York, NY",
        latitude: 40.7060,
        longitude: -74.0036,
        notes: "Send invoice by email. Prefers itemized pricing.",
    )
    
    static let noah = Contact(
        name: "Noah Miller",
        phone: "+1 718 555 0164",
        address: "990 Washington Avenue, Brooklyn, NY",
        latitude: 40.6676,
        longitude: -73.9632,
        notes: "Street parking can be limited near the garden entrance.",
    )
    
    static let ava = Contact(
        name: "Ava Garcia",
        phone: "+1 347 555 0117",
        email: "ava.garcia@example.com",
        address: "Flushing Meadows Corona Park, Queens, NY",
        latitude: 40.7397,
        longitude: -73.8408,
    )
    
    static let ethan = Contact(
        name: "Ethan Anderson",
        address: "1 Fordham Plaza, Bronx, NY",
        latitude: 40.8609,
        longitude: -73.8900,
        notes: "No phone or email on file. Confirm details in person.",
    )
    
    static let mia = Contact(
        name: "Mia Thomas",
        phone: "+1 929 555 0185",
        email: "mia.thomas@example.com",
        address: "St. George Ferry Terminal, Staten Island, NY",
        latitude: 40.6437,
        longitude: -74.0736,
        notes: "Coordinate arrival around ferry schedule.",
    )
    
    static let lucas = Contact(
        name: "Lucas Lee",
        email: "lucas.lee@example.com",
        address: "10 Columbus Circle, New York, NY",
        latitude: 40.7681,
        longitude: -73.9826,
    )
    
    static let isabella = Contact(
        name: "Isabella White",
        phone: "+1 332 555 0109",
        address: "4 Pennsylvania Plaza, New York, NY",
        latitude: 40.7505,
        longitude: -73.9934,
        notes: "Call on arrival. Loading zone is usually available on 31st Street.",
    )
    
    static let mason = Contact(
        name: "Mason Harris",
        address: "281 Park Avenue South, New York, NY",
        latitude: 40.7391,
        longitude: -73.9876,
    )
}

@MainActor
public extension Array where Element == Contact {
    static let mock = [
        Contact.john,
        Contact.emma,
        Contact.david,
        Contact.sophia,
        Contact.liam,
        Contact.olivia,
        Contact.noah,
        Contact.ava,
        Contact.ethan,
        Contact.mia,
        Contact.lucas,
        Contact.isabella,
        Contact.mason,
    ]
}
