// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Model",
            targets: ["Model"]
        )
    ],
    targets: [
        .target(name: "Model")
    ]
)
