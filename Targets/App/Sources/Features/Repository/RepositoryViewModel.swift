import Foundation

struct RepositoryViewModel {
	let items: [Item]
}

extension RepositoryViewModel {
	enum Item {
		case field(name: String, value: String)
		case text(name: String, text: String)
		case markdown(name: String, text: NSAttributedString)
	}
}
