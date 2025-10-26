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
        // Add any external dependencies here, for example:
        // .package(url: "https://github.com/user/repo.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "QKnobs",
            dependencies: [
                // Add dependencies for this target here
            ]
        ),
    ]
)