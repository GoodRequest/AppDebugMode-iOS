// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoodDependencies",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "GoodDependencies",
            targets: ["GoodDependenciesTarget"]
        ),
    ],
   dependencies: [
        .package(url: "https://github.com/GoodRequest/GoodNetworking.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/GoodRequest/GoodLogger.git", .upToNextMajor(from: "1.2.1"))
    ],
    targets: [
        .target(
            name: "GoodDependenciesTarget",
            dependencies: [
                .product(name: "GoodNetworking", package: "GoodNetworking"),
                .product(name: "GoodLogger", package: "GoodLogger")
            ],
            path: ""
        )
    ]
)

