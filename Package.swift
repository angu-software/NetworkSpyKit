// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkSpyKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NetworkSpyKit",
            targets: ["NetworkSpyKit"]),
    ],
    targets: [
        .target(
            name: "NetworkSpyKit"
        ),
        .testTarget(
            name: "NetworkSpyKitTests",
            dependencies: ["NetworkSpyKit"]
        ),
    ]
)
