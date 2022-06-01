import SwiftDI

struct AuthenticationDependency: Dependency {
	let parent: AppDependency
}

func makeAuthenticationCoordinator(
	context: Context<AuthenticationDependency>,
	delegate: AuthenticationCoordinatorDelegate
) -> Scope<AuthenticationDependency, AuthenticationCoordinator> {
	let signInViewControllerFactory = context.make(makeSignInViewController)
	let authenticationCoordinator = AuthenticationCoordinatorImpl(
		window: context.window,
		signInViewControllerFactory: signInViewControllerFactory
	)
	authenticationCoordinator.delegate = delegate
	return Scope(
		parent: AuthenticationDependency(
			parent: context.parent
		),
		result: authenticationCoordinator
	)
}
