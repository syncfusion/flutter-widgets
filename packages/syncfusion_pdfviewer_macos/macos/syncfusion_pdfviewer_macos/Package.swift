// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "syncfusion_pdfviewer_macos",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "syncfusion-pdfviewer-macos", targets: ["syncfusion_pdfviewer_macos"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "syncfusion_pdfviewer_macos",
            dependencies: [],
            resources: []
        )
    ]
)
