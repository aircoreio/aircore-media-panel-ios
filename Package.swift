// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AircoreMediaPanel",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AircoreMediaPanel",
            targets: ["VoicePanelUmbrella"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/aircoreio/aircore-media-ios.git",
            .upToNextMajor(from: "3.0.8")
        )
    ],
    targets: [
        .binaryTarget(
            name: "AircoreMediaPanel",
            path: "./AircoreMediaPanel.xcframework"
        ),
        .target(
            name: "VoicePanelUmbrella",
            dependencies: [
                .product(name: "AircoreMedia", package: "aircore-media-ios"),
                .target(name: "AircoreMediaPanel")
            ],
            path: "./Source"
        )
    ]
)
