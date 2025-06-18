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
            name: "NetworkSpyKit",
            swiftSettings: [
                // Opt into Swift 6 strict concurrency checks during development
                .unsafeFlags(["-Xfrontend", "-enable-actor-data-race-checks",
                              "-Xfrontend", "-strict-concurrency=complete",
                              "-warnings-as-errors"],
                             .when(configuration: .debug))
            ]),
        .testTarget(
            name: "NetworkSpyKitTests",
            dependencies: ["NetworkSpyKit"]
        ),
    ]
)
