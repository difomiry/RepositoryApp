import AsyncDisplayKit
import IGListKit

typealias ASListSectionable = ListSectionable & ASSectionController

protocol ListSectionable where Self: ListSectionController {
	associatedtype Element
	var object: Element? { get set }
}

class ASListSectionController<T>: ListSectionController, ASListSectionable {
	var object: T?

	override func didUpdate(to object: Any) {
		self.object = object as? Element
	}

	override func sizeForItem(at index: Int) -> CGSize {
		ASIGListSectionControllerMethods.sizeForItem(at: index)
	}

	override func cellForItem(at index: Int) -> UICollectionViewCell {
		ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
	}

	// MARK: - ASSectionController

	func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
		return { [unowned self] in
			self.nodeForItem(at: index)
		}
	}

	func nodeForItem(at index: Int) -> ASCellNode {
		fatalError(" Must implements this Method ")
	}
}
