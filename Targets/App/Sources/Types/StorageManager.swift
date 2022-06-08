protocol StorageManager {
	func fetch<T>() async throws -> T where T: Storable
	func fetch<T>() async throws -> [T] where T: Storable
	func save<T>(_ value: T) async throws where T: Storable
	func clear<T>(type: T.Type) async throws where T: Storable
}
