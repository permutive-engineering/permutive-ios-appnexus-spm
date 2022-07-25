// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Permutive_iOS_AppNexus",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Permutive_iOS_AppNexus",
            targets: ["Permutive_iOS_AppNexus"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            url: "https://github.com/permutive-engineering/permutive-ios-spm.git",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/appnexus/mobile-sdk-ios.git",
            .exact("7.22.0")
        )
    ],
    targets: [
        .binaryTarget(name:"Permutive_iOS_AppNexus",
		url:"https://storage.googleapis.com/permutive-ios-sdks/swift-sdk/Permutive_iOS_AppNexus-v1.0.0.zip",
		checksum:"7bf3dd63854fe60b1a6dce86e83475fb02db50ff6706dc5834534e0e75fb4913")
    ]
)
