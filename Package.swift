// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDebugMode",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppDebugMode",
            targets: ["AppDebugMode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/GoodRequest/GoodPersistence.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppDebugMode",
            dependencies: [
                .product(name: "GoodPersistence", package: "GoodPersistence"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ],
            path: "Sources/AppDebugMode"
        ),
        .testTarget(
            name: "AppDebugModeTests",
            dependencies: ["AppDebugMode"]),
    ]
)
