import IGListKit

final class RepositoryMarkdownDiffable: NSObject {
	let name: String
	let text: NSAttributedString

	init(
		name: String,
		text: NSAttributedString
	) {
		self.name = name
		self.text = text
	}
}

extension RepositoryMarkdownDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		(name + text.string) as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? RepositoryMarkdownDiffable else { return false }
		return name == object.name && text == object.text
	}
}
