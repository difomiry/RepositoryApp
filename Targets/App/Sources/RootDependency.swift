import CoreData
import KeychainAccess
import SwiftDI
import UIKit

struct RootDependency: SwiftDI.RootDependency {
	let window: UIWindow
	let authenticationManager: AuthenticationManager
	let apiManager: APIManager
	let httpClient: HTTPClient
	let storageManager: StorageManager
	let credentialsManager: CredentialsManager
}

extension RootDependency {
	static func live(window: UIWindow) throws -> RootDependency {
		let persistentContainer = NSPersistentContainer(name: "RepositoryApp")
		persistentContainer.loadPersistentStores(completionHandler: { _, _ in })
		let httpClient = HTTPClientImpl()
		let credentialsManager = try CredentialsManagerImpl(keychainManager: Keychain())
		let configurationProvider = APIConfigurationProviderImpl()
		let apiManager = APIManagerImpl(
			httpClient: httpClient,
			requestBuilder: APIRequestBuilderImpl(
				credentialsManager: credentialsManager,
				configurationProvider: configurationProvider
			),
			responseMapper: APIResponseMapperImpl(
				configurationProvider: configurationProvider
			)
		)
		return RootDependency(
			window: window,
			authenticationManager: AuthenticationManagerImpl(
				apiManager: apiManager,
				credentialsManager: credentialsManager
			),
			apiManager: apiManager,
			httpClient: httpClient,
			storageManager: StorageManagerImpl(
				persistentContainer: persistentContainer
			),
			credentialsManager: credentialsManager
		)
	}
}
