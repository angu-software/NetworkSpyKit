// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkSpyKit",
    products: [
        .library(
            name: "NetworkSpyKit",
            targets: ["NetworkSpyKit"]),
    ],
    targets: [
        .target(
            name: "NetworkSpyKit"),
        .testTarget(
            name: "NetworkSpyKitTests",
            dependencies: ["NetworkSpyKit"]
        ),
    ]
)
