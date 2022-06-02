import AsyncDisplayKit
import IGListKit

protocol SearchFoundRepositoryListSectionControllerDelegate: AnyObject {
	func didSelect(repository: Repository)
}

final class SearchFoundRepositoryListSectionController: ASListSectionController<SearchFoundRepositoryDiffable> {
	private weak var delegate: SearchFoundRepositoryListSectionControllerDelegate?

	init(delegate: SearchFoundRepositoryListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func didSelectItem(at index: Int) {
		guard let object = object else { return }
		delegate?.didSelect(repository: object.repository)
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return SearchFoundRepositoryCell(
			configuration: SearchFoundRepositoryCellConfiguration(
				name: object.repository.name,
				ownerName: object.repository.owner.name,
				ownerAvatar: object.repository.owner.avatar,
				description: object.repository.description ?? "",
				language: object.repository.language ?? ""
			)
		)
	}
}
