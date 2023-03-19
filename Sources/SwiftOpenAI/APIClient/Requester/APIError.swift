import Foundation

public enum APIError: Error {
    case urlSession(URLError)
    case decodable(DecodingError)
    case jsonResponseError(String)
    case badErrorJSONFormat
    case unknown
}
