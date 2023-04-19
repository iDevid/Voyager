// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Voyager",
    products: [
        .library(
            name: "Voyager",
            targets: ["Voyager", "VoyagerMock"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Voyager",
            dependencies: []
        ),
        .target(
            name: "VoyagerMock",
            dependencies: ["Voyager"],
            path: .some("Sources/Mock")
        ),
        .testTarget(
            name: "VoyagerTests",
            dependencies: ["Voyager"]
        ),
        .testTarget(
            name: "VoyagerMockTests",
            dependencies: ["VoyagerMock"],
            resources: [
                .process("JSON")
            ]
        )
    ]
)
