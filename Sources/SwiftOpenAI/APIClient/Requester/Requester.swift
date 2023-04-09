import Foundation

public protocol RequesterProtocol {
    func execute(with urlRequest: URLRequest) async -> Result<Data, APIError>
}

final public class Requester: RequesterProtocol {
    private let urlSession: URLSession

    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    public func execute(with urlRequest: URLRequest) async -> Result<Data, APIError> {
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode

                if (400...599).contains(statusCode) {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        throw APIError.jsonResponseError(jsonString)
                    } else {
                        throw APIError.unknown
                    }
                }
            } else {
                throw APIError.unknown
            }

            return .success(data)
        } catch let error as URLError {
            return .failure(.urlSession(error))
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
}
