import AsyncDisplayKit
import SwiftDI

typealias RepositoryDependency = EmptyDependency<MainDependency>

func makeRepositoryViewController(
	context: Context<RepositoryDependency>,
	repository: Repository
) -> Scope<RepositoryDependency, RepositoryViewController> {
	let presenter = RepositoryPresenterImpl(
		repository: repository,
		repositoryService: RepositoryServiceImpl(
			apiManager: context.apiManager,
			httpClient: context.httpClient,
			storageManager: context.storageManager
		)
	)
	let viewController = RepositoryViewController(presenter: presenter)
	presenter.view = viewController
	return Scope(
		parent: RepositoryDependency(
			parent: context.parent
		),
		result: viewController
	)
}
