install:
	@type xcodegen >/dev/null 2>&1 || brew install xcodegen
	@type pod >/dev/null 2>&1 || brew install cocoapods
	xcodegen
	pod install
