// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOpenAI",
    platforms: [.iOS(.v13), .macOS(.v12)],
    products: [
        .library(
            name: "SwiftOpenAI",
            targets: ["SwiftOpenAI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "SwiftOpenAI",
            dependencies: [],
            plugins: []),
        .testTarget(
            name: "SwiftOpenAITests",
            dependencies: ["SwiftOpenAI"],
            resources: [
                .process("OpenAITests/Unit Tests/JSON")
            ])
    ]
)
