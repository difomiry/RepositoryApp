import AsyncDisplayKit
import IGListKit

protocol SearchRecentRepositoryListSectionControllerDelegate: AnyObject {
	func didSelect(repository: Repository)
}

final class SearchRecentRepositoryListSectionController: ASListSectionController<SearchRecentRepositoryDiffable> {
	private weak var delegate: SearchRecentRepositoryListSectionControllerDelegate?

	init(delegate: SearchRecentRepositoryListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func didSelectItem(at index: Int) {
		guard let object = object else { return }
		delegate?.didSelect(repository: object.repository)
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return SearchRecentRepositoryCell(
			configuration: SearchRecentRepositoryCellConfiguration(
				name: object.repository.name,
				ownerName: object.repository.owner.name
			)
		)
	}
}
