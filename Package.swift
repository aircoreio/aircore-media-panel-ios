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
            url: "https://github.com/airtimemedia/AirtimeMedia-iOS.git",
            .upToNextMajor(from: "2.0.3")
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
                .product(name: "AirtimeMedia", package: "AirtimeMedia-iOS"),
                .target(name: "AircoreMediaPanel")
            ],
            path: "./Source"
        )
    ]
)
