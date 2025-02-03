// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDebugMode",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppDebugMode",
            targets: ["AppDebugMode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "5.1.1")),
        .package(url: "https://github.com/siteline/swiftui-introspect.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.0.0"),
        .package(url: "https://github.com/GoodRequest/GoodNetworking.git", .upToNextMajor(from: "3.3.1")),
        .package(url: "https://github.com/GoodRequest/GoodLogger.git", .upToNextMajor(from: "1.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppDebugMode",
            dependencies: [
                .product(name: "Pulse", package: "Pulse"),
                .product(name: "PulseUI", package: "Pulse"),
                .product(name: "PulseProxy", package: "Pulse"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
                .product(name: "Factory", package: "Factory"),
                .product(name: "GoodNetworking", package: "GoodNetworking"),
                .product(name: "GoodLogger", package: "GoodLogger")
            ],
            path: "Sources",
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "AppDebugModeTests",
            dependencies: ["AppDebugMode"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
