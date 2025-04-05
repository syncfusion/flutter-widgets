// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "syncfusion_flutter_pdfviewer",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "syncfusion-flutter-pdfviewer", targets: ["syncfusion_flutter_pdfviewer"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "syncfusion_flutter_pdfviewer",
            dependencies: [],
            resources: []
        )
    ]
)