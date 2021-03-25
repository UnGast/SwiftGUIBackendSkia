// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGUIBackendSDL2Skia",
    products: [
        .library(
            name: "SwiftGUIBackendSkia",
            targets: ["SwiftGUIBackendSkia"]),
        .executable(name: "Demo", targets: ["Demo"])
    ],
    dependencies: [
        .package(url: "https://github.com/UnGast/CSDL2.git", .branch("master")),
        .package(name: "SwiftGUI", path: "../swift-gui")
    ],
    targets: [
        .target(
            name: "SwiftGUIBackendSkia",
            dependencies: ["CSDL2", "SwiftGUI", "CSkia"]),
        .target(
            name: "Demo",
            dependencies: ["SwiftGUIBackendSkia", "SwiftGUI"]),
        .target(name: "CSkia", cSettings: [
            .headerSearchPath("../../skia/"),
            .headerSearchPath("../../skia/include/core")
        ], cxxSettings: [
            .headerSearchPath("../../skia/"),
            .headerSearchPath("../../skia/include/core")
        ], linkerSettings: [
            .linkedLibrary("skia"),
            .linkedLibrary("fontconfig")
        ])
   ]
)
