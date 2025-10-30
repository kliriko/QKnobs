// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QKnobs",
    platforms: [
        .iOS(.v26),      // Adjust to your minimum iOS version
        .macOS(.v26),    // Adjust to your minimum macOS version
    ],
    products: [
        .library(
            name: "QKnobs",
            targets: ["QKnobs"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.62.2"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "QKnobs",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
    ]
)
