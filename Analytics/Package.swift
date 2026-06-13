// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Analytics",
            targets: ["Analytics"]
        )
    ],
    dependencies: [
        .package(path: "../Model")
    ],
    targets: [
        .target(
            name: "Analytics",
            dependencies: [
                .product(name: "Model", package: "Model")
            ]
        )
    ]
)
