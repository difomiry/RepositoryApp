import IGListKit

final class SearchFoundRepositoryDiffable: NSObject {
	let repository: Repository

	init(repository: Repository) {
		self.repository = repository
	}
}

extension SearchFoundRepositoryDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		repository.id as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? SearchFoundRepositoryDiffable else { return false }
		return repository.id == object.repository.id
	}
}
