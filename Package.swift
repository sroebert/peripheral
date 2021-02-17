// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Peripheral",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "peripheral", targets: ["Peripheral"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
    ],
    targets: [
        .target(name: "Peripheral", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
    ]
)
