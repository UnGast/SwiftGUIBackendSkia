// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGUIBackendSDL2Skia",
    products: [
        .library(
            name: "SwiftGUIBackendSDL2Skia",
            targets: ["SwiftGUIBackendSDL2Skia"]),
        .executable(name: "Demo", targets: ["Demo"])
    ],
    dependencies: [
        .package(url: "https://github.com/UnGast/CSDL2.git", .branch("master")),
        .package(name: "SwiftGUI", url: "https://github.com/UnGast/swift-gui.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "SwiftGUIBackendSDL2Skia",
            dependencies: ["CSDL2", "SwiftGUI", "CSkia"]),
        .target(
            name: "Demo",
            dependencies: ["SwiftGUIBackendSDL2Skia", "SwiftGUI"]),
        .target(name: "CSkia", cxxSettings: [
            .headerSearchPath("../../skia/"),
            .headerSearchPath("../../skia/include/core")
        ], linkerSettings: [
            .linkedLibrary("skia"),
            .linkedLibrary("fontconfig")
        ])
   ]
)
