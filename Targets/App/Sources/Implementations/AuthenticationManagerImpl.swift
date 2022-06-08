import AuthenticationServices
import KeychainAccess

private struct AccessTokenResponse {
	let token: String
}

extension AccessTokenResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case token = "access_token"
	}
}

final class AuthenticationManagerImpl {
	private let apiManager: APIManager
	private var credentialsManager: CredentialsManager

	init(
		apiManager: APIManager,
		credentialsManager: CredentialsManager
	) {
		self.apiManager = apiManager
		self.credentialsManager = credentialsManager
	}
}

extension AuthenticationManagerImpl: AuthenticationManager {
	var isAuthenticated: Bool { credentialsManager.credentials.token != nil }

	func start(
		with presentationContextProvider: ASWebAuthenticationPresentationContextProviding
	) async throws {
		let code = try await fetchCode(presentationContextProvider: presentationContextProvider)
		let token = try await fetchToken(code: code)
		credentialsManager.credentials.token = token
	}
}

private extension AuthenticationManagerImpl {
	func fetchCode(
		presentationContextProvider: ASWebAuthenticationPresentationContextProviding
	) async throws -> String {
		let url = try URL.makeAuthenticationURL(
			clientID: credentialsManager.credentials.clientID
		)
		return try await withCheckedThrowingContinuation { continuation in
			let session = ASWebAuthenticationSession(
				url: url,
				callbackURLScheme: nil
			) { callbackURL, error in
				guard
					let callbackURL = callbackURL,
					let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
					let code = components.queryItems?.first(where: { $0.name == "code" })?.value
				else {
					return continuation.resume(throwing: error ?? URLError(.badServerResponse))
				}
				continuation.resume(returning: code)
			}
			Task { @MainActor in
				session.presentationContextProvider = presentationContextProvider
				session.start()
			}
		}
	}

	func fetchToken(code: String) async throws -> String {
		let request = APIRequest<AccessTokenResponse>(
			method: "POST",
			components: URLComponents(
				host: "github.com",
				path: "/login/oauth/access_token",
				queryItems: [
					URLQueryItem(name: "client_id", value: credentialsManager.credentials.clientID),
					URLQueryItem(name: "client_secret", value: credentialsManager.credentials.clientSecret),
					URLQueryItem(name: "code", value: code)
				]
			),
			headers: ["Accept": "application/json"],
			isAuthenticationRequired: false
		)
		let response = try await apiManager.perform(request: request)
		return response.token
	}
}

private extension URL {
	static func makeAuthenticationURL(clientID: String) throws -> URL {
		guard
			let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)")
		else {
			throw URLError(.badURL)
		}
		return url
	}
}
