// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Job",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Job",
            targets: ["Job"]
        )
    ],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../Widgets"),
        .package(path: "../AppFoundation"),
        .package(path: "../Contacts"),
    ],
    targets: [
        .target(
            name: "Job",
            dependencies: [
                .product(name: "Model", package: "Model"),
                .product(name: "Widgets", package: "Widgets"),
                .product(name: "AppFoundation", package: "AppFoundation"),
                .product(name: "Contacts", package: "Contacts"),
            ]
        )
    ]
)
