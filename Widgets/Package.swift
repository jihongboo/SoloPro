// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Widgets",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Widgets",
            targets: ["Widgets"]
        )
    ],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../AppFoundation"),
    ],
    targets: [
        .target(
            name: "Widgets",
            dependencies: [
                .product(name: "Model", package: "Model"),
                .product(name: "AppFoundation", package: "AppFoundation"),
            ]
        )
    ]
)
