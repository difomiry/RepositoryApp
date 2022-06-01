import AuthenticationServices

protocol AuthenticationManager {
	var isAuthenticated: Bool { get }
	func start(
		with presentationContextProvider: ASWebAuthenticationPresentationContextProviding
	) async throws
}
