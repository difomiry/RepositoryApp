import Foundation
import Markdown
import Markdownosaur

enum RepositoryViewState {
	enum Value {
		case field(name: String, value: String)
		case text(name: String, text: String)
		case markdown(name: String, text: NSAttributedString)
	}

	case idle
	case values([Value])
}

protocol RepositoryPresenter: AnyObject {
	var view: RepositoryView? { get set }
	var viewState: RepositoryViewState { get }
	func viewDidLoad()
}

final class RepositoryPresenterImpl {
	private var repository: Repository
	private let repositoryService: RepositoryService

	weak var view: RepositoryView?

	private(set) var viewState = RepositoryViewState.idle {
		didSet {
			view?.reloadData()
		}
	}

	init(
		repository: Repository,
		repositoryService: RepositoryService
	) {
		self.repository = repository
		self.repositoryService = repositoryService
	}
}

extension RepositoryPresenterImpl: RepositoryPresenter {
	func viewDidLoad() {
		viewState = build()
		Task {
			do {
				guard let readme = repository.readme, !readme.isEmpty else {
					let readme = try await repositoryService.readme(
						owner: repository.owner.name,
						name: repository.name
					)
					repository.readme = readme
					try await repositoryService.save(repository: repository)
					Task { @MainActor in
						self.viewState = build(with: readme)
					}
					return
				}
				Task { @MainActor in
					self.viewState = build(with: readme)
				}
			} catch {
				try await repositoryService.save(repository: repository)
			}
		}
	}
}

private extension RepositoryPresenterImpl {
	func build(with readme: String? = nil) -> RepositoryViewState {
		var values = [RepositoryViewState.Value]()

		values.append(.field(name: "Name", value: repository.name))
		values.append(.field(name: "Owner", value: repository.owner.name))

		if let description = repository.description {
			values.append(.text(name: "Description", text: description))
		}

		values.append(.field(name: "Forks", value: "\(repository.forks)"))
		values.append(.field(name: "Stargazers", value: "\(repository.stargazers)"))
		values.append(.field(name: "Watchers", value: "\(repository.watchers)"))

		if let readme = readme {
			let document = Document(parsing: readme)
			var markdownosaur = Markdownosaur()
			let attributedString = markdownosaur.attributedString(from: document)
			values.append(.markdown(name: "README", text: attributedString))
		}

		return .values(values)
	}
}
