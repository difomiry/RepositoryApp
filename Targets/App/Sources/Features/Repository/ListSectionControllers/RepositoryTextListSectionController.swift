import AsyncDisplayKit
import IGListKit

protocol RepositoryTextListSectionControllerDelegate: AnyObject {}

final class RepositoryTextListSectionController: ASListSectionController<RepositoryTextDiffable> {
	private weak var delegate: RepositoryTextListSectionControllerDelegate?

	init(delegate: RepositoryTextListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return RepositoryTextCell(
			configuration: RepositoryTextCellConfiguration(
				name: object.name,
				text: object.text
			)
		)
	}
}
