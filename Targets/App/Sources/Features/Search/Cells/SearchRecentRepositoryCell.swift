import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct SearchRecentRepositoryCellConfiguration {
	let name: String
	let ownerName: String
}

final class SearchRecentRepositoryCell: ASCellNode {
	private lazy var ownerName: ASTextNode = {
		return ASTextNode()
	}()

	private lazy var name: ASTextNode = {
		return ASTextNode()
	}()

	init(configuration: SearchRecentRepositoryCellConfiguration) {
		super.init()
		ownerName.attributedText = NSAttributedString(
			string: configuration.ownerName,
			attributes: [
				.font: UIFont.systemFont(ofSize: 15)
			]
		)
		name.attributedText = NSAttributedString(
			string: configuration.name,
			attributes: [
				.font: UIFont.boldSystemFont(ofSize: 15)
			]
		)
		addSubnode(ownerName)
		addSubnode(name)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let stack = ASStackLayoutSpec(
			direction: .vertical,
			spacing: 8,
			justifyContent: .start,
			alignItems: .start,
			children: [
				ownerName,
				name
			]
		)
		stack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 16)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: stack
		)
	}
}
