import Foundation
import Markdown
import Markdownosaur

protocol RepositoryPresenter: AnyObject {
	var view: RepositoryView? { get set }
	var viewModel: RepositoryViewModel { get }
	func viewDidLoad()
}

final class RepositoryPresenterImpl {
	private var repository: Repository
	private let repositoryService: RepositoryService

	weak var view: RepositoryView?

	private(set) var viewModel = RepositoryViewModel(items: []) {
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
		viewModel = build()
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
						self.viewModel = build(with: readme)
					}
					return
				}
				Task { @MainActor in
					self.viewModel = build(with: readme)
				}
			} catch {
				try await repositoryService.save(repository: repository)
			}
		}
	}
}

private extension RepositoryPresenterImpl {
	func build(with readme: String? = nil) -> RepositoryViewModel {
		var items = [RepositoryViewModel.Item]()

		items.append(.field(name: "Name", value: repository.name))
		items.append(.field(name: "Owner", value: repository.owner.name))

		if let description = repository.description, !description.isEmpty {
			items.append(.text(name: "Description", text: description))
		}

		items.append(.field(name: "Forks", value: "\(repository.forks)"))
		items.append(.field(name: "Stargazers", value: "\(repository.stargazers)"))
		items.append(.field(name: "Watchers", value: "\(repository.watchers)"))

		if let readme = readme {
			let document = Document(parsing: readme)
			var markdownosaur = Markdownosaur()
			let attributedString = markdownosaur.attributedString(from: document)
			items.append(.markdown(name: "README", text: attributedString))
		}

		return RepositoryViewModel(items: items)
	}
}
