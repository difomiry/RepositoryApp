import AsyncDisplayKit
import IGListKit

protocol SearchView: AnyObject {
	func reloadData()
}

final class SearchViewController: ASDKViewController<ASCollectionNode>, SearchView {
	private let presenter: SearchPresenter
	private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	private lazy var searchBar = UISearchBar()

	init(presenter: SearchPresenter) {
		self.presenter = presenter
		super.init(node: ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()))
		navigationItem.titleView = searchBar
		searchBar.delegate = self
		node.view.keyboardDismissMode = .interactive
		node.delegate = self
		adapter.setASDKCollectionNode(node)
		adapter.dataSource = self
		node.backgroundColor = .white
		setupKeyboardTracking()
	}

	@available(*, unavailable, message: "init(coder:) has not been implemented")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.viewDidLoad()
	}

	func reloadData() {
		adapter.performUpdates(animated: true)
	}

	private func setupKeyboardTracking() {
		NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillShowNotification,
			object: nil,
			queue: nil
		) { [weak self] notification in
			guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
			let keyboardHeight = keyboardFrame.cgRectValue.height
			self?.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
		}

		NotificationCenter.default.addObserver(
			forName: UIResponder.keyboardWillHideNotification,
			object: nil,
			queue: nil
		) { [weak self] _ in
			self?.additionalSafeAreaInsets = .zero
		}
	}
}

extension SearchViewController: ASCollectionDelegate {
	func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
		!presenter.isIncomplete
	}

	func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
		presenter.didReachEnd()
		context.completeBatchFetching(true)
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBar(_: UISearchBar, textDidChange query: String) {
		presenter.didChange(query: query)
	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.text.map(presenter.didChange)
	}

	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.text.map(presenter.didChange)
	}
}

extension SearchViewController: ListAdapterDataSource {
	func objects(for _: ListAdapter) -> [ListDiffable] {
		var objects = [ListDiffable]()
		if presenter.isAuthenticated {
			objects.append(SearchSignInOrSignOutDiffable(kind: .signOut))
		} else {
			objects.append(SearchSignInOrSignOutDiffable(kind: .signIn))
		}
		switch presenter.viewState {
		case .idle:
				break
		case .failed:
			return []
		case let .loading(repositories):
			guard repositories.isEmpty else {
				objects.append(contentsOf: repositories.map(SearchFoundRepositoryDiffable.init))
				break
			}
			return []
		case let .found(repositories):
			objects.append(contentsOf: repositories.map(SearchFoundRepositoryDiffable.init))
		case let .recent(repositories):
			objects.append(contentsOf: repositories.map(SearchRecentRepositoryDiffable.init))
		}
		return objects
	}

	func listAdapter(_: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		switch object {
		case is SearchSignInOrSignOutDiffable:
			return SearchSignInOrSignOutListSectionController(delegate: self)
		case is SearchFoundRepositoryDiffable:
			return SearchFoundRepositoryListSectionController(delegate: self)
		case is SearchRecentRepositoryDiffable:
			return SearchRecentRepositoryListSectionController(delegate: self)
		default:
			return ListSectionController()
		}
	}

	func emptyView(for _: ListAdapter) -> UIView? {
		switch presenter.viewState {
		case .idle:
			return nil
		case .loading:
			return activityIndicator()
		case .found:
			return emptyView(message: "Nothing is found")
		case .recent:
			return emptyView(message: "Type to search")
		case let .failed(error):
			return emptyView(message: error.localizedDescription)
		}
	}

	private func activityIndicator() -> UIView {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.startAnimating()
		return activityIndicator
	}

	private func emptyView(message: String) -> UIView {
		let label = UILabel()
		label.numberOfLines = 0
		label.text = message
		label.textAlignment = .center
		return label
	}
}

extension SearchViewController: SearchFoundRepositoryListSectionControllerDelegate, SearchRecentRepositoryListSectionControllerDelegate {
	func didSelect(repository: Repository) {
		presenter.didSelect(repository: repository)
	}
}

extension SearchViewController: SearchSignInOrSignOutListSectionControllerDelegate {
	func didTapSignIn() {
		presenter.didTapSignIn()
	}

	func didTapSignOut() {
		presenter.didTapSignOut()
	}
}
