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
            dependencies: ["MuckCLI"]),
        .target(
            name: "MuckCore",
            path: "Sources/Muck",
            exclude: ["Finder", "Raker"],
            sources: ["Core", "Reporter", "Transformer", "Utility"]),
        .target(
            name: "MuckSourceKit",
            dependencies: [
                "MuckCore",
                .product(name: "SourceKittenFramework", package: "SourceKitten")
            ],
            path: "Sources/Muck/Finder"),
        .target(
            name: "MuckCLI",
            dependencies: [
                "MuckCore",
                "MuckSourceKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/Muck/Raker"),
        .testTarget(
            name: "MuckTests",
            dependencies: ["MuckCore", "MuckSourceKit", "MuckCLI"]),
    ]
)
