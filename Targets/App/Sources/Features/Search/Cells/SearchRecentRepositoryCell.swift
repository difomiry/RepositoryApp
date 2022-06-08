import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct SearchRecentRepositoryCellConfiguration {
	let name: String
	let ownerName: String
	let description: String
	let language: String
}

final class SearchRecentRepositoryCell: ASCellNode {
	private lazy var name: ASTextNode = .init()

	private lazy var desc: ASTextNode = .init()

	private lazy var language: ASTextNode = .init()

	init(configuration: SearchRecentRepositoryCellConfiguration) {
		super.init()
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
		let stack = ASStackLayoutSpec(
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
		stack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 16)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: stack
		)
	}
}
