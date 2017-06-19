// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "Swiftz",
	products: [
        .library(
            name: "Swiftz",
            targets: ["Swiftz"]),
    ],
	dependencies: [
		.package(url: "https://github.com/tcldr/Swiftx.git", .branch("swift-4")),
		.package(url: "https://github.com/typelift/SwiftCheck.git", .branch("master"))
	],
	targets: [
		.target(
            name: "Swiftz",
            dependencies: ["Swiftx"]),
        .testTarget(
            name: "SwiftzTests",
            dependencies: ["Swiftz", "SwiftCheck"]),
	]
)

