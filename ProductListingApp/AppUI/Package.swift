// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AppUI",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AppUI", targets: ["AppUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "AppUI",
            dependencies: ["Kingfisher"]
        )
    ]
)
