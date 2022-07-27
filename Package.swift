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
		checksum:"11a137d58434309d3ff6420112d34b36f750c3a534bc5dac9705ab6f25f1e74e")
    ]
)
