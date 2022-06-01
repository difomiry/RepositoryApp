import IGListKit

final class RepositoryTextDiffable: NSObject {
	let name: String
	let text: String

	init(
		name: String,
		text: String
	) {
		self.name = name
		self.text = text
	}
}

extension RepositoryTextDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		(name + text) as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? RepositoryTextDiffable else { return false }
		return name == object.name && text == object.text
	}
}
