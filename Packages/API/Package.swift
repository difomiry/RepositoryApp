// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "API",
	platforms: [.iOS(.v13)],
	products: [
		.library(
			name: "API",
			targets: ["API"]
		)
	],
	targets: [
		.target(
			name: "API",
			dependencies: []
		)
	]
)
