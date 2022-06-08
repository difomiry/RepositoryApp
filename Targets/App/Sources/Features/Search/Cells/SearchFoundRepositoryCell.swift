import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct SearchFoundRepositoryCellConfiguration {
	let name: String
	let ownerName: String
	let ownerAvatar: String
	let description: String
	let language: String
}

final class SearchFoundRepositoryCell: ASCellNode {
	private lazy var ownerAvatar: ASNetworkImageNode = .init()

	private lazy var name: ASTextNode = .init()

	private lazy var desc: ASTextNode = .init()

	private lazy var language: ASTextNode = .init()

	init(configuration: SearchFoundRepositoryCellConfiguration) {
		super.init()
		ownerAvatar.setURL(URL(string: configuration.ownerAvatar), resetToDefault: true)
		addSubnode(ownerAvatar)

		let nameAttributedString = NSMutableAttributedString()
		nameAttributedString.append(
			NSAttributedString(
				string: configuration.ownerName,
				attributes: [
					.font: UIFont.systemFont(ofSize: 15)
				]
			)
		)
		nameAttributedString.append(
			NSAttributedString(
				string: "/",
				attributes: [
					.font: UIFont.systemFont(ofSize: 15)
				]
			)
		)
		nameAttributedString.append(
			NSAttributedString(
				string: configuration.name,
				attributes: [
					.font: UIFont.boldSystemFont(ofSize: 15)
				]
			)
		)
		name.attributedText = nameAttributedString
		addSubnode(name)

		if !configuration.description.isEmpty {
			desc.attributedText = NSAttributedString(
				string: configuration.description,
				attributes: [
					.font: UIFont.systemFont(ofSize: 15)
				]
			)
			addSubnode(desc)
		}

		if !configuration.language.isEmpty {
			language.attributedText = NSAttributedString(
				string: configuration.language,
				attributes: [
					.font: UIFont.systemFont(ofSize: 13),
					.foregroundColor: UIColor.gray
				]
			)
			addSubnode(language)
		}
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
				name,
				subnodes?.contains(desc) == true ? desc : nil,
				subnodes?.contains(language) == true ? language : nil
			].compactMap { $0 }
		)
		textStack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 72)
		let stack = ASStackLayoutSpec(
			direction: .horizontal,
			spacing: 8,
			justifyContent: .center,
			alignItems: .start,
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
