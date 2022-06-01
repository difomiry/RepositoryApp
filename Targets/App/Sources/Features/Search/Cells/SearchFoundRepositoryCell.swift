import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct SearchFoundRepositoryCellConfiguration {
	let name: String
	let ownerName: String
	let ownerAvatar: String
}

final class SearchFoundRepositoryCell: ASCellNode {
	private lazy var ownerAvatar: ASNetworkImageNode = {
		return ASNetworkImageNode()
	}()

	private lazy var ownerName: ASTextNode = {
		return ASTextNode()
	}()

	private lazy var name: ASTextNode = {
		return ASTextNode()
	}()

	init(configuration: SearchFoundRepositoryCellConfiguration) {
		super.init()
		ownerAvatar.setURL(URL(string: configuration.ownerAvatar), resetToDefault: true)
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
		addSubnode(ownerAvatar)
		addSubnode(ownerName)
		addSubnode(name)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		ownerAvatar.style.preferredLayoutSize = .init(
			width: .init(unit: .points, value: 50),
			height: .init(unit: .points, value: 50)
		)
		let textStack = ASStackLayoutSpec(
			direction: .vertical,
			spacing: 8,
			justifyContent: .start,
			alignItems: .start,
			children: [
				ownerName,
				name
			]
		)
		textStack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 72)
		let stack = ASStackLayoutSpec(
			direction: .horizontal,
			spacing: 8,
			justifyContent: .center,
			alignItems: .center,
			children: [
				ownerAvatar,
				textStack
			]
		)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: stack
		)
	}
}
