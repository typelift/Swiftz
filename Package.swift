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
		.package(url: "https://github.com/typelift/Swiftx.git", from: "0.6.0"),
		.package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.9.0")
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

