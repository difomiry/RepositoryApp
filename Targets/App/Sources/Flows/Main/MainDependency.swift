import SwiftDI

struct MainDependency: Dependency {
	let parent: AppDependency
}

func makeMainCoordinator(
	context: Context<MainDependency>,
	delegate: MainCoordinatorDelegate
) -> Scope<MainDependency, MainCoordinator> {
	let searchViewControllerFactory = context.make(makeSearchViewController)
	let profileViewControllerFactory = context.make(makeProfileViewController)
	let repositoryViewControllerFactory = context.make(makeRepositoryViewController)
	let coordinator = MainCoordinatorImpl(
		window: context.window,
		searchViewControllerFactory: searchViewControllerFactory,
		profileViewControllerFactory: profileViewControllerFactory,
		repositoryViewControllerFactory: repositoryViewControllerFactory
	)
	coordinator.delegate = delegate
	return Scope(
		parent: MainDependency(
			parent: context.parent
		),
		result: coordinator
	)
}
