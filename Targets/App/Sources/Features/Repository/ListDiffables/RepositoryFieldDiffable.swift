import IGListKit

final class RepositoryFieldDiffable: NSObject {
	let name: String
	let value: String

	init(
		name: String,
		value: String
	) {
		self.name = name
		self.value = value
	}
}

extension RepositoryFieldDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		(name + value) as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? RepositoryFieldDiffable else { return false }
		return name == object.name && value == object.value
	}
}
