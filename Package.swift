// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "APIManager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "APIManager",
            targets: ["APIManager"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "APIManager",
            dependencies: []),
        .testTarget(
            name: "APIManagerTests",
            dependencies: ["APIManager"]),
    ]
)

