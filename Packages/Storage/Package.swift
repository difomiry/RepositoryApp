// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "Storage",
	platforms: [.iOS(.v13)],
	products: [
		.library(
			name: "Storage",
			targets: ["Storage"]
		)
	],
	targets: [
		.target(
			name: "Storage",
			dependencies: []
		)
	]
)
