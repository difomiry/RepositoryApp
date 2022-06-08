import AsyncDisplayKit
import IGListKit

protocol RepositoryView: AnyObject {
	func reloadData()
}

final class RepositoryViewController: ASDKViewController<ASCollectionNode>, RepositoryView {
	private let presenter: RepositoryPresenter
	private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)

	init(presenter: RepositoryPresenter) {
		self.presenter = presenter
		super.init(node: ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()))
		title = "Repository"
		adapter.setASDKCollectionNode(node)
		adapter.dataSource = self
		node.backgroundColor = .white
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
}

extension RepositoryViewController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		presenter.viewModel.items.map { item in
			switch item {
			case let .field(name, value):
				return RepositoryFieldDiffable(name: name, value: value) as ListDiffable
			case let .text(name, text):
				return RepositoryTextDiffable(name: name, text: text) as ListDiffable
			case let .markdown(name, text):
				return RepositoryMarkdownDiffable(name: name, text: text) as ListDiffable
			}
		}
	}

	func listAdapter(_: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		switch object {
		case is RepositoryFieldDiffable:
			return RepositoryFieldListSectionController(delegate: self)
		case is RepositoryTextDiffable:
			return RepositoryTextListSectionController(delegate: self)
		case is RepositoryMarkdownDiffable:
			return RepositoryMarkdownListSectionController(delegate: self)
		default:
			return ListSectionController()
		}
	}

	func emptyView(for _: ListAdapter) -> UIView? {
		nil
	}
}

extension RepositoryViewController:
	RepositoryFieldListSectionControllerDelegate,
	RepositoryTextListSectionControllerDelegate,
	RepositoryMarkdownListSectionControllerDelegate {}
