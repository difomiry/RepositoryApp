import Combine
import Foundation

protocol SearchPresenterDelegate: AnyObject {
	func didTap(repository: Repository)
}

protocol SearchPresenter: AnyObject {
	var view: SearchView? { get set }
	var viewModel: SearchViewModel { get }
	var isIncomplete: Bool { get }
	func viewDidLoad()
	func didChange(query: String)
	func didSelect(repository: Repository)
	func didReachEnd()
}

final class SearchPresenterImpl {
	private let searchService: SearchService

	weak var delegate: SearchPresenterDelegate?
	weak var view: SearchView?

	private var query = PassthroughSubject<String, Error>()
	private var lastQuery: String?
	private var cancellables = Set<AnyCancellable>()
	private var task: Task<Void, Error>?
	private var page = 1
	private(set) var isIncomplete = false
	private(set) var viewModel = SearchViewModel.idle {
		didSet {
			Task { @MainActor in
				self.view?.reloadData()
			}
		}
	}

	init(
		delegate: SearchPresenterDelegate,
		searchService: SearchService
	) {
		self.delegate = delegate
		self.searchService = searchService
	}
}

extension SearchPresenterImpl: SearchPresenter {
	func didChange(query: String) {
		self.query.send(query)
	}

	func viewDidLoad() {
		query
			.debounce(for: 0.5, scheduler: RunLoop.main)
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.sink(receiveCompletion: { _ in }, receiveValue: performSearch)
			.store(in: &cancellables)
		fetchRecent()
	}

	func didSelect(repository: Repository) {
		delegate?.didTap(repository: repository)
	}

	func didReachEnd() {
		guard
			case let .found(repositories) = viewModel,
			!isIncomplete,
			let lastQuery = lastQuery
		else { return }
		page += 1
		viewModel = .loading(repositories)
		task?.cancel()
		task = Task {
			do {
				let response = try await searchService.search(query: lastQuery, page: page)
				Task { @MainActor in
					self.isIncomplete = response.isIncomplete
					if case let .loading(repositories) = self.viewModel {
						self.viewModel = .found(repositories + response.items)
					} else {
						self.viewModel = .found(response.items)
					}
				}
			} catch {
				if (error as NSError).code == -999 { return }
				Task { @MainActor in
					self.viewModel = .failed(error)
				}
			}
		}
	}
}

private extension SearchPresenterImpl {
	func performSearch(query: String) {
		guard lastQuery != query else { return }
		lastQuery = query
		page = 1
		guard !query.isEmpty else {
			return fetchRecent()
		}
		viewModel = .loading([])
		task?.cancel()
		task = Task {
			do {
				let response = try await searchService.search(query: query, page: page)
				Task { @MainActor in
					self.isIncomplete = response.isIncomplete
					self.viewModel = .found(response.items)
				}
			} catch {
				if (error as NSError).code == -999 { return }
				Task { @MainActor in
					self.viewModel = .failed(error)
				}
			}
		}
	}

	func fetchRecent() {
		task?.cancel()
		task = Task {
			do {
				let repositories = try await searchService.recent()
				Task { @MainActor in
					self.viewModel = .recent(repositories.reversed())
				}
			} catch {
				// do nothing
			}
		}
	}
}
