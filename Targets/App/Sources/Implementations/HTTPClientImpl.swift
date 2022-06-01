import Foundation

final class HTTPClientImpl {
	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}
}

extension HTTPClientImpl: HTTPClient {
	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		final class Box { var task: URLSessionTask? }
		let box = Box()
		return try await withTaskCancellationHandler {
			box.task?.cancel()
		} operation: {
			try await withCheckedThrowingContinuation { continuation in
				box.task = session.dataTask(with: request) { data, response, error in
					guard let data = data, let response = response else {
						let error = error ?? URLError(.badServerResponse)
						return continuation.resume(throwing: error)
					}
					continuation.resume(returning: (data, response))
				}
				box.task?.resume()
		 }
		}
	}
}
