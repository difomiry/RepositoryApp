import KeychainAccess

final class CredentialsManagerImpl: CredentialsManager {
	private let keychainManager: Keychain
	var credentials: Credentials {
		didSet {
			keychainManager["token"] = credentials.token
		}
	}

	init(keychainManager: Keychain) throws {
		self.keychainManager = keychainManager
		guard
			let clientID = Bundle.main.object(forInfoDictionaryKey: "GITHUB_API_CLIENT_ID") as? String,
			let clientSecret = Bundle.main.object(forInfoDictionaryKey: "GITHUB_API_CLIENT_SECRET") as? String
		else {
			throw CredentialsError.notFound
		}
		let token = keychainManager[string: "token"]
		self.credentials = Credentials(
			clientID: clientID,
			clientSecret: clientSecret,
			token: token
		)
	}
}
