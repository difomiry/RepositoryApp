import AsyncDisplayKit
import SwiftDI

typealias ProfileDependency = EmptyDependency<MainDependency>

func makeProfileViewController(
	context: Context<ProfileDependency>,
	delegate: ProfilePresenterDelegate
) -> Scope<ProfileDependency, ProfileViewController> {
	let presenter = ProfilePresenterImpl(
		delegate: delegate,
		userService: UserServiceImpl(
			apiManager: context.apiManager
		),
		repositoryService: RepositoryServiceImpl(
			apiManager: context.apiManager,
			httpClient: context.httpClient,
			storageManager: context.storageManager
		),
		credentialsManager: context.credentialsManager
	)
	let viewController = ProfileViewController(presenter: presenter)
	presenter.view = viewController
	return Scope(
		parent: ProfileDependency(
			parent: context.parent
		),
		result: viewController
	)
}
