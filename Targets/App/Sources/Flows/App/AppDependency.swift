import SwiftDI

struct AppDependency: Dependency {
	let parent: RootDependency
}

func makeAppCoordinator(
	context: Context<AppDependency>
) -> Scope<AppDependency, AppCoordinator> {
	let authenticationCoordinatorFactory = context.make(makeAuthenticationCoordinator)
	let mainCoordinatorFactory = context.make(makeMainCoordinator)
	return Scope(
		parent: AppDependency(
			parent: context.parent
		),
		result: AppCoordinatorImpl(
			authenticationManager: context.authenticationManager,
			authenticationCoordinatorFactory: authenticationCoordinatorFactory,
			mainCoordinatorFactory: mainCoordinatorFactory
		)
	)
}
