import PackageDescription

let package = Package(
	name: "Swiftz",
	targets: [
		Target(name: "Swiftz")
	],
	dependencies: [
		.Package(url: "https://github.com/typelift/Operadics.git", versions: Version(0,2,2)...Version(0,2,2)),
		.Package(url: "https://github.com/typelift/Swiftx.git", versions: Version(0,5,1)...Version(0,5,1)),
	]
)

