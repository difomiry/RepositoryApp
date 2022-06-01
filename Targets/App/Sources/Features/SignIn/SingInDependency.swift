import AsyncDisplayKit
import SwiftDI

typealias SignInDependency = EmptyDependency<AuthenticationDependency>

func makeSignInViewController(
	context: Context<SignInDependency>,
	delegate: SignInPresenterDelegate
) -> Scope<SignInDependency, SignInViewController> {
	let presenter = SignInPresenterImpl(
		delegate: delegate,
		authenticationManager: context.authenticationManager
	)
	let viewController = SignInViewController(
		presenter: presenter
	)
	return Scope(
		parent: SignInDependency(
			parent: context.parent
		),
		result: viewController
	)
}
