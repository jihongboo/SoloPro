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
        address: "350 5th Avenue, New York, NY",
        latitude: 40.7484,
        longitude: -73.9857,
        price: 120,
        notes: "Bring carpet cleaner. Customer prefers the service elevator.",
        status: .scheduled,
        customer: Contact.john
    )
    
    static let sinkRepair = Job(
        title: "Sink Repair",
        date: mockDate(hour: 11, minute: 30),
        address: "200 Central Park West, New York, NY",
        latitude: 40.7813,
        longitude: -73.9735,
        price: 180,
        status: .inProgress,
        customer: Contact.emma
    )
    
    static let exteriorPaintingEstimate = Job(
        title: "Exterior Painting Estimate",
        date: mockDate(daysFromToday: 1, hour: 15),
        address: "11 Wall Street, New York, NY",
        latitude: 40.7074,
        longitude: -74.0113,
        price: 75,
        notes: "Estimate only. Email quote after inspection.",
        status: .scheduled,
        customer: Contact.david
    )
    
    static let gutterCleaning = Job(
        title: "Gutter Cleaning",
        date: mockDate(daysFromToday: -1, hour: 14, minute: 30),
        address: "30 Rockefeller Plaza, New York, NY",
        latitude: 40.7587,
        longitude: -73.9787,
        price: 95,
        notes: "Completed ahead of schedule. Customer requested a follow-up quote for roof moss treatment.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -7, hour: 10),
        customer: Contact.sophia
    )
    
    static let applianceInstall = Job(
        title: "Appliance Install",
        date: mockDate(hour: 16, minute: 45),
        address: "405 Lexington Avenue, New York, NY",
        latitude: 40.7517,
        longitude: -73.9753,
        price: 240,
        notes: "Building has limited loading access after 5 PM.",
        status: .scheduled,
        customer: Contact.liam
    )
    
    static let deckInspection = Job(
        title: "Deck Inspection",
        date: mockDate(daysFromToday: 2, hour: 8, minute: 30),
        address: "89 South Street, New York, NY",
        latitude: 40.7060,
        longitude: -74.0036,
        price: 0,
        notes: "Free estimate. No customer profile attached yet.",
        status: .scheduled
    )
    
    static let canceledWindowCleaning = Job(
        title: "Window Cleaning",
        date: mockDate(daysFromToday: 3, hour: 13),
        address: "990 Washington Avenue, Brooklyn, NY",
        latitude: 40.6676,
        longitude: -73.9632,
        price: 160,
        notes: "Canceled by customer due to travel. Needs rescheduling next month.",
        status: .canceled,
        createdAt: mockDate(daysFromToday: -2, hour: 9, minute: 15),
        customer: Contact.noah
    )
    
    static let cabinetTouchUp = Job(
        title: "Cabinet Touch-Up",
        date: mockDate(daysFromToday: -3, hour: 10, minute: 15),
        address: "Flushing Meadows Corona Park, Queens, NY",
        latitude: 40.7397,
        longitude: -73.8408,
        price: 65,
        status: .completed,
        createdAt: mockDate(daysFromToday: -10, hour: 12),
        customer: Contact.ava
    )
    
    static let hvacTuneUp = Job(
        title: "HVAC Tune-Up",
        date: mockDate(daysFromToday: 1, hour: 10),
        address: "1 Fordham Plaza, Bronx, NY",
        latitude: 40.8609,
        longitude: -73.8900,
        price: 140,
        notes: "Check rooftop unit access with building manager.",
        status: .scheduled,
        customer: Contact.ethan
    )
    
    static let tileRepair = Job(
        title: "Tile Repair",
        date: mockDate(daysFromToday: 1, hour: 13, minute: 30),
        address: "St. George Ferry Terminal, Staten Island, NY",
        latitude: 40.6437,
        longitude: -74.0736,
        price: 210,
        notes: "Match white subway tile. Bring extra grout samples.",
        status: .scheduled,
        customer: Contact.mia
    )
    
    static let lightFixtureInstall = Job(
        title: "Light Fixture Install",
        date: mockDate(daysFromToday: 2, hour: 12),
        address: "10 Columbus Circle, New York, NY",
        latitude: 40.7681,
        longitude: -73.9826,
        price: 85,
        status: .scheduled,
        customer: Contact.lucas
    )
    
    static let doorLockReplacement = Job(
        title: "Door Lock Replacement",
        date: mockDate(daysFromToday: 2, hour: 17),
        address: "4 Pennsylvania Plaza, New York, NY",
        latitude: 40.7505,
        longitude: -73.9934,
        price: 130,
        notes: "Customer asked for two spare keys.",
        status: .scheduled,
        customer: Contact.isabella
    )
    
    static let drywallPatch = Job(
        title: "Drywall Patch",
        date: mockDate(daysFromToday: -2, hour: 9, minute: 45),
        address: "281 Park Avenue South, New York, NY",
        latitude: 40.7391,
        longitude: -73.9876,
        price: 155,
        status: .completed,
        createdAt: mockDate(daysFromToday: -8, hour: 15),
        customer: Contact.mason
    )
    
    static let furnitureAssembly = Job(
        title: "Furniture Assembly",
        date: mockDate(daysFromToday: 4, hour: 10, minute: 30),
        address: "55 Water Street, New York, NY",
        latitude: 40.7035,
        longitude: -74.0091,
        price: 110,
        notes: "Bring drill bits and felt pads. Client has parking validation.",
        status: .scheduled,
        customer: Contact.olivia
    )
    
    static let plumbingInspection = Job(
        title: "Plumbing Inspection",
        date: mockDate(daysFromToday: 5, hour: 8),
        address: "Brooklyn Borough Hall, Brooklyn, NY",
        latitude: 40.6928,
        longitude: -73.9903,
        price: 0,
        status: .scheduled
    )
    
    static let garageDoorService = Job(
        title: "Garage Door Service",
        date: mockDate(daysFromToday: -5, hour: 16),
        address: "Yankee Stadium, Bronx, NY",
        latitude: 40.8296,
        longitude: -73.9262,
        price: 175,
        notes: "Replaced worn rollers and tested opener twice.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -12, hour: 11, minute: 30),
        customer: Contact.noah
    )
    
    static let landscapingQuote = Job(
        title: "Landscaping Quote",
        date: mockDate(daysFromToday: 6, hour: 14),
        address: "Queens Botanical Garden, Queens, NY",
        latitude: 40.7515,
        longitude: -73.8267,
        price: 0,
        notes: "Measure side yard and price seasonal cleanup separately.",
        status: .scheduled,
        customer: Contact.ava
    )
    
    static let emergencyLeakRepair = Job(
        title: "Emergency Leak Repair",
        date: mockDate(hour: 18, minute: 15),
        address: "Union Square, New York, NY",
        latitude: 40.7359,
        longitude: -73.9911,
        price: 320,
        notes: "Active leak under kitchen sink. Prioritize same-day completion.",
        status: .inProgress,
        customer: Contact.sophia
    )
    
    static let completedPaintTouchUp = Job(
        title: "Paint Touch-Up",
        date: mockDate(daysFromToday: -4, hour: 9),
        address: "Bryant Park, New York, NY",
        latitude: 40.7536,
        longitude: -73.9832,
        price: 125,
        notes: "Touched up hallway scuffs and matched existing paint.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -11, hour: 14),
        customer: Contact.john
    )
    
    static let completedBathroomCaulking = Job(
        title: "Bathroom Caulking",
        date: mockDate(daysFromToday: -6, hour: 11, minute: 30),
        address: "Chelsea Market, New York, NY",
        latitude: 40.7423,
        longitude: -74.0060,
        price: 90,
        status: .completed,
        createdAt: mockDate(daysFromToday: -13, hour: 10),
        customer: Contact.emma
    )
    
    static let completedShelfMounting = Job(
        title: "Shelf Mounting",
        date: mockDate(daysFromToday: -7, hour: 15),
        address: "Washington Square Park, New York, NY",
        latitude: 40.7308,
        longitude: -73.9973,
        price: 115,
        notes: "Mounted three floating shelves into studs.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -14, hour: 9),
        customer: Contact.david
    )
    
    static let completedFaucetReplacement = Job(
        title: "Faucet Replacement",
        date: mockDate(daysFromToday: -8, hour: 10),
        address: "The Met Fifth Avenue, New York, NY",
        latitude: 40.7794,
        longitude: -73.9632,
        price: 185,
        notes: "Replaced kitchen faucet and checked supply lines.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -16, hour: 16),
        customer: Contact.sophia
    )
    
    static let completedOutletRepair = Job(
        title: "Outlet Repair",
        date: mockDate(daysFromToday: -9, hour: 13, minute: 15),
        address: "Lincoln Center, New York, NY",
        latitude: 40.7725,
        longitude: -73.9835,
        price: 105,
        status: .completed,
        createdAt: mockDate(daysFromToday: -15, hour: 11),
        customer: Contact.liam
    )
    
    static let completedClosetDoorFix = Job(
        title: "Closet Door Fix",
        date: mockDate(daysFromToday: -10, hour: 8, minute: 45),
        address: "The High Line, New York, NY",
        latitude: 40.7480,
        longitude: -74.0048,
        price: 80,
        notes: "Adjusted sliding track and replaced one roller.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -18, hour: 12),
        customer: Contact.olivia
    )
    
    static let completedPressureWashing = Job(
        title: "Pressure Washing",
        date: mockDate(daysFromToday: -11, hour: 14),
        address: "Brooklyn Bridge Park, Brooklyn, NY",
        latitude: 40.7003,
        longitude: -73.9967,
        price: 260,
        status: .completed,
        createdAt: mockDate(daysFromToday: -19, hour: 9, minute: 30),
        customer: Contact.noah
    )
    
    static let completedGardenCleanup = Job(
        title: "Garden Cleanup",
        date: mockDate(daysFromToday: -12, hour: 12),
        address: "Prospect Park, Brooklyn, NY",
        latitude: 40.6602,
        longitude: -73.9690,
        price: 150,
        notes: "Removed leaves and hauled two bags of debris.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -20, hour: 15),
        customer: Contact.ava
    )
    
    static let completedDoorTrimRepair = Job(
        title: "Door Trim Repair",
        date: mockDate(daysFromToday: -13, hour: 16),
        address: "Grand Army Plaza, Brooklyn, NY",
        latitude: 40.6740,
        longitude: -73.9701,
        price: 135,
        status: .completed,
        createdAt: mockDate(daysFromToday: -21, hour: 8),
        customer: Contact.ethan
    )
    
    static let completedWasherHookup = Job(
        title: "Washer Hookup",
        date: mockDate(daysFromToday: -14, hour: 9, minute: 30),
        address: "Astoria Park, Queens, NY",
        latitude: 40.7797,
        longitude: -73.9220,
        price: 170,
        notes: "Installed hoses and verified no leaks after test cycle.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -22, hour: 13),
        customer: Contact.mia
    )
    
    static let completedCeilingFanInstall = Job(
        title: "Ceiling Fan Install",
        date: mockDate(daysFromToday: -15, hour: 11),
        address: "Socrates Sculpture Park, Queens, NY",
        latitude: 40.7686,
        longitude: -73.9364,
        price: 195,
        status: .completed,
        createdAt: mockDate(daysFromToday: -23, hour: 10),
        customer: Contact.lucas
    )
    
    static let completedFenceGateRepair = Job(
        title: "Fence Gate Repair",
        date: mockDate(daysFromToday: -16, hour: 15, minute: 30),
        address: "Forest Park, Queens, NY",
        latitude: 40.7016,
        longitude: -73.8545,
        price: 145,
        notes: "Replaced hinge screws and realigned latch.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -24, hour: 11),
        customer: Contact.isabella
    )
    
    static let completedSumpPumpCheck = Job(
        title: "Sump Pump Check",
        date: mockDate(daysFromToday: -17, hour: 8),
        address: "Pelham Bay Park, Bronx, NY",
        latitude: 40.8656,
        longitude: -73.8079,
        price: 100,
        status: .completed,
        createdAt: mockDate(daysFromToday: -25, hour: 16),
        customer: Contact.mason
    )
    
    static let completedMailboxRepair = Job(
        title: "Mailbox Repair",
        date: mockDate(daysFromToday: -18, hour: 13),
        address: "Van Cortlandt Park, Bronx, NY",
        latitude: 40.8979,
        longitude: -73.8835,
        price: 70,
        notes: "Reattached loose mailbox and sealed mounting holes.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -26, hour: 9),
        customer: Contact.john
    )
    
    static let completedHandrailInstall = Job(
        title: "Handrail Install",
        date: mockDate(daysFromToday: -19, hour: 10, minute: 30),
        address: "Bronx Zoo, Bronx, NY",
        latitude: 40.8506,
        longitude: -73.8769,
        price: 230,
        status: .completed,
        createdAt: mockDate(daysFromToday: -27, hour: 14),
        customer: Contact.emma
    )
    
    static let completedPatioFurnitureRepair = Job(
        title: "Patio Furniture Repair",
        date: mockDate(daysFromToday: -20, hour: 12, minute: 45),
        address: "Snug Harbor Cultural Center, Staten Island, NY",
        latitude: 40.6426,
        longitude: -74.1019,
        price: 125,
        notes: "Tightened hardware and replaced missing foot glides.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -28, hour: 10),
        customer: Contact.david
    )
    
    static let completedStormDoorAdjustment = Job(
        title: "Storm Door Adjustment",
        date: mockDate(daysFromToday: -21, hour: 14),
        address: "Clove Lakes Park, Staten Island, NY",
        latitude: 40.6187,
        longitude: -74.1143,
        price: 95,
        status: .completed,
        createdAt: mockDate(daysFromToday: -29, hour: 12),
        customer: Contact.sophia
    )
    
    static let completedBlindInstallation = Job(
        title: "Blind Installation",
        date: mockDate(daysFromToday: -22, hour: 9),
        address: "Fort Tryon Park, New York, NY",
        latitude: 40.8626,
        longitude: -73.9327,
        price: 160,
        notes: "Installed four blinds and removed old hardware.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -30, hour: 15),
        customer: Contact.liam
    )
    
    static let completedSmokeDetectorService = Job(
        title: "Smoke Detector Service",
        date: mockDate(daysFromToday: -23, hour: 11, minute: 15),
        address: "Battery Park, New York, NY",
        latitude: 40.7033,
        longitude: -74.0170,
        price: 75,
        status: .completed,
        createdAt: mockDate(daysFromToday: -31, hour: 9),
        customer: Contact.olivia
    )
    
    static let completedGeneralMaintenance = Job(
        title: "General Maintenance",
        date: mockDate(daysFromToday: -24, hour: 16, minute: 30),
        address: "Randall's Island Park, New York, NY",
        latitude: 40.7932,
        longitude: -73.9213,
        price: 200,
        notes: "Completed punch list items across kitchen and hallway.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -32, hour: 13)
    )
    
    static let todayGarageShelfInstall = Job(
        title: "Garage Shelf Install",
        date: mockDate(hour: 8, minute: 15),
        address: "Madison Square Park, New York, NY",
        latitude: 40.7420,
        longitude: -73.9876,
        price: 135,
        notes: "Install two wall-mounted shelves before noon.",
        status: .scheduled,
        customer: Contact.mason
    )
    
    static let todayThermostatSetup = Job(
        title: "Thermostat Setup",
        date: mockDate(hour: 13, minute: 45),
        address: "Flatiron Building, New York, NY",
        latitude: 40.7411,
        longitude: -73.9897,
        price: 95,
        status: .scheduled,
        customer: Contact.olivia
    )
    
    static let tomorrowWindowScreenRepair = Job(
        title: "Window Screen Repair",
        date: mockDate(daysFromToday: 1, hour: 8, minute: 45),
        address: "Little Island, New York, NY",
        latitude: 40.7420,
        longitude: -74.0103,
        price: 115,
        status: .scheduled,
        customer: Contact.john
    )
    
    static let tomorrowClosetOrganizer = Job(
        title: "Closet Organizer",
        date: mockDate(daysFromToday: 1, hour: 16, minute: 30),
        address: "Pier 57, New York, NY",
        latitude: 40.7433,
        longitude: -74.0108,
        price: 220,
        notes: "Bring wall anchors for plaster walls.",
        status: .scheduled,
        customer: Contact.emma
    )
    
    static let dayTwoGroutRefresh = Job(
        title: "Grout Refresh",
        date: mockDate(daysFromToday: 2, hour: 14, minute: 30),
        address: "New York Public Library, New York, NY",
        latitude: 40.7532,
        longitude: -73.9822,
        price: 145,
        status: .scheduled,
        customer: Contact.david
    )
    
    static let dayTwoSmokeAlarmInstall = Job(
        title: "Smoke Alarm Install",
        date: mockDate(daysFromToday: 2, hour: 18),
        address: "42nd Street Bryant Park, New York, NY",
        latitude: 40.7540,
        longitude: -73.9845,
        price: 90,
        notes: "Install three detectors and test each unit.",
        status: .scheduled,
        customer: Contact.sophia
    )
    
    static let dayThreeDryerVentCleaning = Job(
        title: "Dryer Vent Cleaning",
        date: mockDate(daysFromToday: 3, hour: 9),
        address: "Brooklyn Museum, Brooklyn, NY",
        latitude: 40.6712,
        longitude: -73.9636,
        price: 130,
        status: .scheduled,
        customer: Contact.noah
    )
    
    static let dayThreePictureHanging = Job(
        title: "Picture Hanging",
        date: mockDate(daysFromToday: 3, hour: 11, minute: 30),
        address: "Brooklyn Heights Promenade, Brooklyn, NY",
        latitude: 40.6960,
        longitude: -73.9977,
        price: 75,
        status: .scheduled,
        customer: Contact.ava
    )
    
    static let dayThreeKitchenHardware = Job(
        title: "Kitchen Hardware",
        date: mockDate(daysFromToday: 3, hour: 15, minute: 45),
        address: "Domino Park, Brooklyn, NY",
        latitude: 40.7150,
        longitude: -73.9670,
        price: 125,
        notes: "Replace pulls on 18 cabinet doors.",
        status: .scheduled,
        customer: Contact.ethan
    )
    
    static let dayFourToiletRepair = Job(
        title: "Toilet Repair",
        date: mockDate(daysFromToday: 4, hour: 8, minute: 30),
        address: "Queens Museum, Queens, NY",
        latitude: 40.7458,
        longitude: -73.8467,
        price: 160,
        status: .scheduled,
        customer: Contact.mia
    )
    
    static let dayFourBaseboardRepair = Job(
        title: "Baseboard Repair",
        date: mockDate(daysFromToday: 4, hour: 13),
        address: "MoMA PS1, Queens, NY",
        latitude: 40.7455,
        longitude: -73.9471,
        price: 140,
        notes: "Prime patched section after repair.",
        status: .scheduled,
        customer: Contact.lucas
    )
    
    static let dayFiveDoorbellInstall = Job(
        title: "Doorbell Install",
        date: mockDate(daysFromToday: 5, hour: 10, minute: 15),
        address: "Gantry Plaza State Park, Queens, NY",
        latitude: 40.7465,
        longitude: -73.9573,
        price: 150,
        status: .scheduled,
        customer: Contact.isabella
    )
    
    static let dayFiveFenceEstimate = Job(
        title: "Fence Estimate",
        date: mockDate(daysFromToday: 5, hour: 15, minute: 30),
        address: "Juniper Valley Park, Queens, NY",
        latitude: 40.7208,
        longitude: -73.8780,
        price: 0,
        notes: "Measure rear fence and price gate replacement separately.",
        status: .scheduled
    )
    
    static let daySixMirrorMounting = Job(
        title: "Mirror Mounting",
        date: mockDate(daysFromToday: 6, hour: 9, minute: 30),
        address: "Wave Hill, Bronx, NY",
        latitude: 40.8976,
        longitude: -73.9123,
        price: 110,
        status: .scheduled,
        customer: Contact.john
    )
    
    static let daySixLeakInspection = Job(
        title: "Leak Inspection",
        date: mockDate(daysFromToday: 6, hour: 16),
        address: "New York Botanical Garden, Bronx, NY",
        latitude: 40.8623,
        longitude: -73.8770,
        price: 85,
        status: .scheduled,
        customer: Contact.emma
    )
    
    static let yesterdayCompletedShelfRepair = Job(
        title: "Shelf Repair",
        date: mockDate(daysFromToday: -1, hour: 9, minute: 15),
        address: "Cooper Union, New York, NY",
        latitude: 40.7294,
        longitude: -73.9903,
        price: 95,
        status: .completed,
        createdAt: mockDate(daysFromToday: -6, hour: 11),
        customer: Contact.david
    )
    
    static let yesterdayCompletedDrainClearing = Job(
        title: "Drain Clearing",
        date: mockDate(daysFromToday: -1, hour: 16),
        address: "East River Park, New York, NY",
        latitude: 40.7178,
        longitude: -73.9747,
        price: 180,
        notes: "Cleared bathroom drain and flushed line twice.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -5, hour: 13),
        customer: Contact.sophia
    )
    
    static let completedDayTwoLightSwitch = Job(
        title: "Light Switch Repair",
        date: mockDate(daysFromToday: -2, hour: 13, minute: 30),
        address: "Hudson Yards, New York, NY",
        latitude: 40.7540,
        longitude: -74.0020,
        price: 105,
        status: .completed,
        createdAt: mockDate(daysFromToday: -7, hour: 10),
        customer: Contact.liam
    )
    
    static let completedDayTwoWindowLatch = Job(
        title: "Window Latch Repair",
        date: mockDate(daysFromToday: -2, hour: 17),
        address: "Vessel, New York, NY",
        latitude: 40.7538,
        longitude: -74.0022,
        price: 80,
        status: .completed,
        createdAt: mockDate(daysFromToday: -8, hour: 12),
        customer: Contact.olivia
    )
    
    static let completedDayThreePipeInsulation = Job(
        title: "Pipe Insulation",
        date: mockDate(daysFromToday: -3, hour: 8),
        address: "Brooklyn Navy Yard, Brooklyn, NY",
        latitude: 40.6984,
        longitude: -73.9724,
        price: 155,
        notes: "Wrapped exposed basement pipes.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -9, hour: 14),
        customer: Contact.noah
    )
    
    static let completedDayThreeDoorCloser = Job(
        title: "Door Closer Adjustment",
        date: mockDate(daysFromToday: -3, hour: 15),
        address: "Barclays Center, Brooklyn, NY",
        latitude: 40.6826,
        longitude: -73.9754,
        price: 90,
        status: .completed,
        createdAt: mockDate(daysFromToday: -9, hour: 9),
        customer: Contact.ava
    )
    
    static let completedDayFourVanityInstall = Job(
        title: "Vanity Install",
        date: mockDate(daysFromToday: -4, hour: 12, minute: 30),
        address: "Roosevelt Island Tramway, New York, NY",
        latitude: 40.7614,
        longitude: -73.9642,
        price: 280,
        status: .completed,
        createdAt: mockDate(daysFromToday: -12, hour: 11),
        customer: Contact.ethan
    )
    
    static let completedDayFourCaulkTouchUp = Job(
        title: "Caulk Touch-Up",
        date: mockDate(daysFromToday: -4, hour: 16, minute: 45),
        address: "Carl Schurz Park, New York, NY",
        latitude: 40.7751,
        longitude: -73.9436,
        price: 70,
        status: .completed,
        createdAt: mockDate(daysFromToday: -12, hour: 15),
        customer: Contact.mia
    )
    
    static let completedDayFiveClosetRod = Job(
        title: "Closet Rod Replacement",
        date: mockDate(daysFromToday: -5, hour: 9, minute: 45),
        address: "Arthur Ashe Stadium, Queens, NY",
        latitude: 40.7505,
        longitude: -73.8469,
        price: 120,
        status: .completed,
        createdAt: mockDate(daysFromToday: -13, hour: 10),
        customer: Contact.lucas
    )
    
    static let completedDayFiveStepRepair = Job(
        title: "Step Repair",
        date: mockDate(daysFromToday: -5, hour: 13, minute: 15),
        address: "Citi Field, Queens, NY",
        latitude: 40.7571,
        longitude: -73.8458,
        price: 190,
        notes: "Re-secured loose tread and checked railing.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -14, hour: 9),
        customer: Contact.isabella
    )
    
    static let completedDaySixScreenDoor = Job(
        title: "Screen Door Repair",
        date: mockDate(daysFromToday: -6, hour: 14),
        address: "Flushing Town Hall, Queens, NY",
        latitude: 40.7638,
        longitude: -73.8307,
        price: 100,
        status: .completed,
        createdAt: mockDate(daysFromToday: -15, hour: 12),
        customer: Contact.mason
    )
    
    static let completedDaySevenGutterPatch = Job(
        title: "Gutter Patch",
        date: mockDate(daysFromToday: -7, hour: 10, minute: 30),
        address: "Fort Greene Park, Brooklyn, NY",
        latitude: 40.6913,
        longitude: -73.9752,
        price: 130,
        status: .completed,
        createdAt: mockDate(daysFromToday: -16, hour: 11),
        customer: Contact.john
    )
    
    static let completedDaySevenCabinetHinge = Job(
        title: "Cabinet Hinge Repair",
        date: mockDate(daysFromToday: -7, hour: 17, minute: 15),
        address: "Brooklyn Botanic Garden, Brooklyn, NY",
        latitude: 40.6676,
        longitude: -73.9632,
        price: 85,
        notes: "Adjusted soft-close hinges on pantry doors.",
        status: .completed,
        createdAt: mockDate(daysFromToday: -17, hour: 8),
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
        Job.cabinetTouchUp,
        Job.hvacTuneUp,
        Job.tileRepair,
        Job.lightFixtureInstall,
        Job.doorLockReplacement,
        Job.drywallPatch,
        Job.furnitureAssembly,
        Job.plumbingInspection,
        Job.garageDoorService,
        Job.landscapingQuote,
        Job.emergencyLeakRepair,
        Job.completedPaintTouchUp,
        Job.completedBathroomCaulking,
        Job.completedShelfMounting,
        Job.completedFaucetReplacement,
        Job.completedOutletRepair,
        Job.completedClosetDoorFix,
        Job.completedPressureWashing,
        Job.completedGardenCleanup,
        Job.completedDoorTrimRepair,
        Job.completedWasherHookup,
        Job.completedCeilingFanInstall,
        Job.completedFenceGateRepair,
        Job.completedSumpPumpCheck,
        Job.completedMailboxRepair,
        Job.completedHandrailInstall,
        Job.completedPatioFurnitureRepair,
        Job.completedStormDoorAdjustment,
        Job.completedBlindInstallation,
        Job.completedSmokeDetectorService,
        Job.completedGeneralMaintenance,
        Job.todayGarageShelfInstall,
        Job.todayThermostatSetup,
        Job.tomorrowWindowScreenRepair,
        Job.tomorrowClosetOrganizer,
        Job.dayTwoGroutRefresh,
        Job.dayTwoSmokeAlarmInstall,
        Job.dayThreeDryerVentCleaning,
        Job.dayThreePictureHanging,
        Job.dayThreeKitchenHardware,
        Job.dayFourToiletRepair,
        Job.dayFourBaseboardRepair,
        Job.dayFiveDoorbellInstall,
        Job.dayFiveFenceEstimate,
        Job.daySixMirrorMounting,
        Job.daySixLeakInspection,
        Job.yesterdayCompletedShelfRepair,
        Job.yesterdayCompletedDrainClearing,
        Job.completedDayTwoLightSwitch,
        Job.completedDayTwoWindowLatch,
        Job.completedDayThreePipeInsulation,
        Job.completedDayThreeDoorCloser,
        Job.completedDayFourVanityInstall,
        Job.completedDayFourCaulkTouchUp,
        Job.completedDayFiveClosetRod,
        Job.completedDayFiveStepRepair,
        Job.completedDaySixScreenDoor,
        Job.completedDaySevenGutterPatch,
        Job.completedDaySevenCabinetHinge,
    ]
}
