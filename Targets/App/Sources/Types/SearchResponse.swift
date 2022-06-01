struct SearchResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case items
		case isIncomplete = "incomplete_results"
	}
	
	let items: [Repository]
	let isIncomplete: Bool
}
