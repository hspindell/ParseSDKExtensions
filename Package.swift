// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ParseSDKExtensions",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ParseSDKExtensions",
            targets: ["ParseSDKExtensions"]),
    ],
    dependencies: [
        // parse-community -> netreconlab github when ready for Parse 5+
        .package(url: "https://github.com/parse-community/Parse-Swift", .upToNextMajor(from: "2.5.1")),
        .package(url: "https://github.com/modernistik/Modernistik", from: "0.4.9"),
        .package(url: "https://github.com/hspindell/TimeZoneLocate", from: "0.6.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ParseSDKExtensions",
            dependencies: [
                .product(name: "ParseSwift", package: "Parse-Swift"),
                .product(name: "Modernistik", package: "Modernistik"),
                .product(name: "TimeZoneLocate", package: "TimeZoneLocate")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ParseSDKExtensionsTests",
            dependencies: ["ParseSDKExtensions"]),
    ]
)
