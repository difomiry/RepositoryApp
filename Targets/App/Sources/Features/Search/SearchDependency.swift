import AsyncDisplayKit
import SwiftDI

typealias SearchDependency = EmptyDependency<MainDependency>

func makeSearchViewController(
	context: Context<SearchDependency>,
	delegate: SearchPresenterDelegate
) -> Scope<SearchDependency, SearchViewController> {
	let presenter = SearchPresenterImpl(
		delegate: delegate,
		searchService: SearchServiceImpl(
			apiManager: context.apiManager,
			storageManager: context.storageManager
		)
	)
	let viewController = SearchViewController(presenter: presenter)
	presenter.view = viewController
	return Scope(
		parent: SearchDependency(
			parent: context.parent
		),
		result: viewController
	)
}
