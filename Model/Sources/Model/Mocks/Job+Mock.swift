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
        address: "上海市黄浦区南京东路123号",
        latitude: 31.2356,
        longitude: 121.4747,
        price: 120,
        notes: "Bring carpet cleaner.",
        status: .scheduled,
        customer: Contact.john
    )
    
    static let sinkRepair = Job(
        title: "Sink Repair",
        date: mockDate(hour: 11, minute: 30),
        address: "上海市徐汇区淮海中路999号",
        latitude: 31.2067,
        longitude: 121.4494,
        price: 180,
        status: .inProgress,
        customer: Contact.emma
    )
    
    static let exteriorPaintingEstimate = Job(
        title: "Exterior Painting Estimate",
        date: mockDate(daysFromToday: 1, hour: 15),
        address: "上海市浦东新区陆家嘴环路700号",
        latitude: 31.2397,
        longitude: 121.4998,
        price: 75,
        status: .scheduled,
        customer: Contact.david
    )
    
    static let gutterCleaning = Job(
        title: "Gutter Cleaning",
        date: mockDate(daysFromToday: -1, hour: 14, minute: 30),
        address: "上海市静安区愚园路256号",
        latitude: 31.2277,
        longitude: 121.4437,
        price: 95,
        notes: "Completed ahead of schedule. Customer requested a follow-up quote for roof moss treatment.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -7, hour: 10),
        customer: Contact.john
    )
    
    static let applianceInstall = Job(
        title: "Appliance Install",
        date: mockDate(hour: 16, minute: 45),
        address: "上海市长宁区仙霞路91号4B室",
        latitude: 31.2076,
        longitude: 121.4040,
        price: 240,
        notes: "Building has limited loading access after 5 PM.",
        status: .scheduled,
        customer: Contact.emma
    )
    
    static let deckInspection = Job(
        title: "Deck Inspection",
        date: mockDate(daysFromToday: 2, hour: 8, minute: 30),
        address: "上海市杨浦区大学路809号",
        latitude: 31.3072,
        longitude: 121.5141,
        price: 0,
        notes: "Free estimate. No customer profile attached yet.",
        status: .scheduled
    )
    
    static let canceledWindowCleaning = Job(
        title: "Window Cleaning",
        date: mockDate(daysFromToday: 3, hour: 13),
        address: "上海市虹口区四川北路32号",
        latitude: 31.2597,
        longitude: 121.4821,
        price: 160,
        notes: "Canceled by customer due to travel. Needs rescheduling next month.",
        status: .canceled,
        createdAt: mockDate(daysFromToday: -2, hour: 9, minute: 15),
        customer: Contact.john
    )
    
    static let cabinetTouchUp = Job(
        title: "Cabinet Touch-Up",
        date: mockDate(daysFromToday: -3, hour: 10, minute: 15),
        address: "上海市普陀区中山北路88号",
        latitude: 31.2513,
        longitude: 121.4145,
        price: 65,
        status: .completed,
        createdAt: mockDate(daysFromToday: -10, hour: 12),
        customer: Contact.emma
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
        Job.deckInspection,
        Job.canceledWindowCleaning,
        Job.cabinetTouchUp
    ]
}
