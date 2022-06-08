import AsyncDisplayKit
import IGListKit

protocol ProfileView: AnyObject {
	func reloadData()
}

final class ProfileViewController: ASDKViewController<ASCollectionNode>, ProfileView {
	private let presenter: ProfilePresenter
	private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)

	init(presenter: ProfilePresenter) {
		self.presenter = presenter
		super.init(node: ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()))
		title = "Profile"
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

extension ProfileViewController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		presenter.viewModel.items.map { item in
			switch item {
			case let .avatar(avatar):
				return ProfileAvatarDiffable(avatar: avatar) as ListDiffable
			case let .field(text):
				return ProfileFieldDiffable(text: text) as ListDiffable
			case let .button(kind):
				return ProfileButtonDiffable(kind: kind) as ListDiffable
			}
		}
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		switch object {
		case is ProfileAvatarDiffable:
			return ProfileAvatarListSectionController(delegate: self)
		case is ProfileFieldDiffable:
			return ProfileFieldListSectionController(delegate: self)
		case is ProfileButtonDiffable:
			return ProfileButtonListSectionController(delegate: self)
		default:
			return ListSectionController()
		}
	}

	func emptyView(for listAdapter: ListAdapter) -> UIView? {
		nil
	}
}

extension ProfileViewController: ProfileAvatarListSectionControllerDelegate,
	ProfileFieldListSectionControllerDelegate {}

extension ProfileViewController: ProfileButtonListSectionControllerDelegate {
	func didTapButton(kind: ProfileViewModel.ButtonKind) {
		presenter.didTapButton(kind: kind)
	}
}
