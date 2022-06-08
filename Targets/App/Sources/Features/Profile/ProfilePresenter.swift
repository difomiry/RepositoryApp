import Foundation
import Markdown
import Markdownosaur

protocol ProfilePresenterDelegate: AnyObject {
	func didFinishProfile()
}

protocol ProfilePresenter: AnyObject {
	var view: ProfileView? { get set }
	var viewModel: ProfileViewModel { get }
	func viewDidLoad()
	func didTapButton(kind: ProfileViewModel.ButtonKind)
}

final class ProfilePresenterImpl {
	private let userService: UserService
	private let repositoryService: RepositoryService
	private let credentialsManager: CredentialsManager

	weak var view: ProfileView?
	weak var delegate: ProfilePresenterDelegate?

	private(set) var viewModel = ProfileViewModel(items: []) {
		didSet {
			view?.reloadData()
		}
	}

	init(
		delegate: ProfilePresenterDelegate,
		userService: UserService,
		repositoryService: RepositoryService,
		credentialsManager: CredentialsManager
	) {
		self.delegate = delegate
		self.userService = userService
		self.repositoryService = repositoryService
		self.credentialsManager = credentialsManager
	}
}

extension ProfilePresenterImpl: ProfilePresenter {
	func viewDidLoad() {
		viewModel = build()
		Task {
			do {
				let user = try await userService.current()
				Task { @MainActor in
					self.viewModel = self.build(with: user)
				}
			} catch {}
		}
	}

	func didTapButton(kind: ProfileViewModel.ButtonKind) {
		switch kind {
		case .signIn:
			delegate?.didFinishProfile()
		case .signOut:
			credentialsManager.credentials.token = nil
			Task {
				do {
					try await repositoryService.clear()
				} catch {}
			}
			delegate?.didFinishProfile()
		}
	}
}

private extension ProfilePresenterImpl {
	func build(with user: User? = nil) -> ProfileViewModel {
		var items = [ProfileViewModel.Item]()

		if let user = user {
			items.append(.avatar(avatar: user.avatar))
			items.append(.field(text: user.name))
		}

		if credentialsManager.credentials.token == nil {
			items.append(.button(kind: .signIn))
		} else {
			items.append(.button(kind: .signOut))
		}

		return ProfileViewModel(items: items)
	}
}
