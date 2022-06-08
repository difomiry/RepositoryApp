import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct ProfileButtonCellConfiguration {
	let title: String
}

final class ProfileButtonCell: ASCellNode {
	private lazy var button: ASButtonNode = {
		let node = ASButtonNode()
		node.backgroundColor = .systemBlue
		return node
	}()

	init(configuration: ProfileButtonCellConfiguration) {
		super.init()
		button.setTitle(
			configuration.title,
			with: .systemFont(ofSize: 17),
			with: .white,
			for: .normal
		)
		addSubnode(button)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		button.style.preferredSize = .init(
			width: constrainedSize.max.width - 32,
			height: 56
		)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: button
		)
	}
}
