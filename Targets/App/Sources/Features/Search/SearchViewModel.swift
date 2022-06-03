enum SearchViewModel {
	case idle
	case loading([Repository])
	case found([Repository])
	case recent([Repository])
	case failed(Error)
}
