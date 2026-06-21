// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Contacts",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Contacts",
            targets: ["Contacts"]
        )
    ],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../Widgets"),
    ],
    targets: [
        .target(
            name: "Contacts",
            dependencies: [
                .product(name: "Widgets", package: "Widgets"),
                .product(name: "Model", package: "Model"),
            ]
        )
    ]
)
