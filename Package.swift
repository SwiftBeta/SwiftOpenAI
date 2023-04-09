// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOpenAI",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "SwiftOpenAI",
            targets: ["SwiftOpenAI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.2.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.51.0")
    ],
    targets: [
        .target(
            name: "SwiftOpenAI",
            dependencies: [],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "SwiftOpenAITests",
            dependencies: ["SwiftOpenAI"],
            resources: [
                .process("OpenAITests/Unit Tests/JSON")
            ]),
    ]
)
