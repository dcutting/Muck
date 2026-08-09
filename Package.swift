// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Muck",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "muck", targets: ["MuckApp"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.38.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "MuckApp",
            dependencies: [
                "Muck",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(
            name: "Muck",
            dependencies: [
                .product(name: "SourceKittenFramework", package: "SourceKitten"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "MuckTests",
            dependencies: ["Muck"]),
    ]
)
