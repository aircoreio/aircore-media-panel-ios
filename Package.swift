// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AircoreMediaPanel",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AircoreMediaPanel",
            targets: ["AircoreMediaPanelWrapper"]
        ),
    ],
    dependencies: [
        .package(
            url: "git@github.com:airtimemedia/AirtimeMedia-iOS.git",
            .upToNextMajor(from: "1.5.2")
        )
    ],
    targets: [
        .binaryTarget(
            name: "AircoreMediaPanel",
            path: "./AircoreMediaPanel.xcframework"
        ),
        .target(
            name: "AircoreMediaPanelWrapper",
            dependencies: [
                .product(name: "AirtimeMedia", package: "AirtimeMedia-iOS"),
                .target(name: "AircoreMediaPanel")
            ],
            path: "./Source"
        )
    ]
)
