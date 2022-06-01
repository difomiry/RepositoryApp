import Combine
import Foundation

protocol SearchPresenterDelegate: AnyObject {
	func didTap(repository: Repository)
	func didFinishSearch()
}

enum SearchViewState {
	case idle
	case loading([Repository])
	case found([Repository])
	case recent([Repository])
	case failed(Error)
}

protocol SearchPresenter: AnyObject {
	var view: SearchView? { get set }
	var viewState: SearchViewState { get }
	var isIncomplete: Bool { get }
	var isAuthenticated: Bool { get }
	func viewDidLoad()
	func didChange(query: String)
	func didSelect(repository: Repository)
	func didReachEnd()
	func didTapSignIn()
	func didTapSignOut()
}

final class SearchPresenterImpl {
	private let searchService: SearchService
	private let credentialsManager: CredentialsManager

	weak var delegate: SearchPresenterDelegate?
	weak var view: SearchView?

	private var query = PassthroughSubject<String, Error>()
	private var lastQuery: String?
	private var cancellables = Set<AnyCancellable>()
	private var task: Task<Void, Error>?
	private var page = 1
	private(set) var isIncomplete = false
	private(set) var viewState = SearchViewState.idle {
		didSet {
			Task { @MainActor in
				self.view?.reloadData()
			}
		}
	}

	init(
		delegate: SearchPresenterDelegate,
		searchService: SearchService,
		credentialsManager: CredentialsManager
	) {
		self.delegate = delegate
		self.searchService = searchService
		self.credentialsManager = credentialsManager
	}
}

extension SearchPresenterImpl: SearchPresenter {
	var isAuthenticated: Bool { credentialsManager.credentials.token != nil }

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
			case let .found(repositories) = viewState,
			!isIncomplete,
			let lastQuery = lastQuery
		else { return }
		page += 1
		viewState = .loading(repositories)
		task?.cancel()
		task = Task {
			do {
				let response = try await searchService.search(query: lastQuery, page: page)
				Task { @MainActor in
					self.isIncomplete = response.isIncomplete
					if case let .loading(repositories) = self.viewState {
						self.viewState = .found(repositories + response.items)
					} else {
						self.viewState = .found(response.items)
					}
				}
			} catch {
				if (error as NSError).code == -999 { return }
				Task { @MainActor in
					self.viewState = .failed(error)
				}
			}
		}
	}

	func didTapSignIn() {
		delegate?.didFinishSearch()
	}

	func didTapSignOut() {
		credentialsManager.credentials.token = nil
		delegate?.didFinishSearch()
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
		viewState = .loading([])
		task?.cancel()
		task = Task {
			do {
				let response = try await searchService.search(query: query, page: page)
				Task { @MainActor in
					self.isIncomplete = response.isIncomplete
					self.viewState = .found(response.items)
				}
			} catch {
				if (error as NSError).code == -999 { return }
				Task { @MainActor in
					self.viewState = .failed(error)
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
					self.viewState = .recent(repositories.reversed())
				}
			} catch {
				// do nothing
			}
		}
	}
}
