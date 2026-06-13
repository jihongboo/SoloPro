//
//  File.swift
//  Model
//
//  Created by 纪洪波 on 2026/6/13.
//

import Foundation

@MainActor
public extension Job {
    static let mock = Job.deepCleaning
    
    static let deepCleaning = Job(
        title: "Deep Cleaning",
        date: mockDate(hour: 9),
        address: "123 Main Street",
        price: 120,
        notes: "Bring carpet cleaner.",
        status: .scheduled,
        customer: Customer.john
    )
    
    static let sinkRepair = Job(
        title: "Sink Repair",
        date: mockDate(hour: 11, minute: 30),
        address: "48 Oak Avenue",
        price: 180,
        status: .inProgress,
        customer: Customer.emma
    )
    
    static let exteriorPaintingEstimate = Job(
        title: "Exterior Painting Estimate",
        date: mockDate(daysFromToday: 1, hour: 15),
        address: "700 Pine Road",
        price: 75,
        status: .scheduled,
        customer: Customer.david
    )
    
    static let gutterCleaning = Job(
        title: "Gutter Cleaning",
        date: mockDate(daysFromToday: -1, hour: 14, minute: 30),
        address: "256 Cedar Lane",
        price: 95,
        notes: "Completed ahead of schedule. Customer requested a follow-up quote for roof moss treatment.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -7, hour: 10),
        customer: Customer.john
    )
    
    static let applianceInstall = Job(
        title: "Appliance Install",
        date: mockDate(hour: 16, minute: 45),
        address: "91 Market Street, Apt 4B",
        price: 240,
        notes: "Building has limited loading access after 5 PM.",
        status: .scheduled,
        customer: Customer.emma
    )
    
    static let emergencyLeakRepair = Job(
        title: "Emergency Leak Repair",
        date: mockDate(hour: 20, minute: 15),
        address: "14 River Court",
        price: 325,
        notes: "Same-day urgent request. Check under kitchen sink and upstairs bathroom before closing the job.",
        status: .inProgress,
        createdAt: mockDate(hour: 7, minute: 45),
        customer: Customer.david
    )
    
    static let deckInspection = Job(
        title: "Deck Inspection",
        date: mockDate(daysFromToday: 2, hour: 8, minute: 30),
        address: "809 Willow Drive",
        price: 0,
        notes: "Free estimate. No customer profile attached yet.",
        status: .scheduled
    )
    
    static let canceledWindowCleaning = Job(
        title: "Window Cleaning",
        date: mockDate(daysFromToday: 3, hour: 13),
        address: "32 Lake View Road",
        price: 160,
        notes: "Canceled by customer due to travel. Needs rescheduling next month.",
        status: .canceled,
        createdAt: mockDate(daysFromToday: -2, hour: 9, minute: 15),
        customer: Customer.john
    )
    
    static let cabinetTouchUp = Job(
        title: "Cabinet Touch-Up",
        date: mockDate(daysFromToday: -3, hour: 10, minute: 15),
        address: "48 Oak Avenue",
        price: 65,
        status: .completed,
        createdAt: mockDate(daysFromToday: -10, hour: 12),
        customer: Customer.emma
    )
    
    private static func mockDate(daysFromToday: Int = 0, hour: Int, minute: Int = 0) -> Date {
        let calendar = Calendar.current
        let baseDate = calendar.date(byAdding: .day, value: daysFromToday, to: Date()) ?? Date()
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: baseDate) ?? baseDate
    }
}

@MainActor
public extension Array where Element == Job {
    static let mock = [
        Job.deepCleaning,
        Job.sinkRepair,
        Job.exteriorPaintingEstimate,
        Job.gutterCleaning,
        Job.applianceInstall,
        Job.emergencyLeakRepair,
        Job.deckInspection,
        Job.canceledWindowCleaning,
        Job.cabinetTouchUp
    ]
}
