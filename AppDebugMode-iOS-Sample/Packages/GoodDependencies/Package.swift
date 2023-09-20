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
       .package(url: "https://github.com/GoodRequest/GoodNetworking.git", .upToNextMajor(from: "1.0.2")),
       .package(url: "git@github.com:GoodRequest/AppDebugMode-iOS.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "GoodDependenciesTarget",
            dependencies: [
                .product(name: "GoodNetworking", package: "GoodNetworking"),
                .product(name: "Mockable", package: "GoodNetworking"),
                .product(name: "AppDebugMode", package: "AppDebugMode-iOS")
            ],
            path: ""
        )
    ]
)

