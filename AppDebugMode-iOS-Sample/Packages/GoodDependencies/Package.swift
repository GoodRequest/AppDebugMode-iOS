// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "GoodDependencies",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "GoodDependencies",
            targets: ["GoodDependenciesTarget"]
        ),
    ],
   dependencies: [
       .package(url: "https://github.com/GoodRequest/GoodNetworking.git", .branch("feat/messagePublisher"))
    ],
    targets: [
        .target(
            name: "GoodDependenciesTarget",
            dependencies: [
                .product(name: "GoodNetworking", package: "GoodNetworking"),
                .product(name: "Mockable", package: "GoodNetworking")
            ],
            path: ""
        )
    ]
)

