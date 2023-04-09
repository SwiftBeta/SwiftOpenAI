import Foundation

public protocol ParserProtocol {
    func parse<T: Decodable, E: Decodable & Error>(_ data: Result<Data, APIError>,
                                                   type: T.Type,
                                                   jsonDecoder: JSONDecoder, errorType: E.Type) throws -> T?
    func parse<T: Decodable>(_ data: Data, type: T.Type, jsonDecoder: JSONDecoder) throws -> T?
}

final public class Parser: ParserProtocol {
    public init() { }

    public func parse<T: Decodable, E: Decodable & Error>(_ result: Result<Data, APIError>,
                                                          type: T.Type,
                                                          jsonDecoder: JSONDecoder = .init(),
                                                          errorType: E.Type) throws -> T? {
        switch result {
        case .success(let data):
            let dataModel = try parse(data, type: T.self, jsonDecoder: jsonDecoder)
            return dataModel
        case .failure(let error):
            let errorDataModel = try parseError(apiError: error, type: E.self)
            throw errorDataModel ?? error
        }
    }

    public func parse<T: Decodable>(_ data: Data,
                                    type: T.Type,
                                    jsonDecoder: JSONDecoder = .init()) throws -> T? {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            printDecodable(error: error)

            throw APIError.decodable(error)
        }
    }

    public func parseError<E: Decodable & Error>(apiError: APIError,
                                                 type: E.Type,
                                                 jsonDecoder: JSONDecoder = .init()) throws -> E? {
        guard case APIError.jsonResponseError(let jsonString) = apiError,
              let jsonData = jsonString.data(using: .utf8) else {
            throw apiError
        }

        do {
            let decodedErrorModel = try jsonDecoder.decode(E.self, from: jsonData)
            return decodedErrorModel
        } catch {
            throw error
        }
    }
}

extension Parser {
    func printDecodable(error: DecodingError) {
        let message: String
        switch error {
        case .keyNotFound(let key, let context):
            message = "[APIClient] Decoding Error: Key \"\(key)\" not found \nContext: \(context.debugDescription)"
        case .dataCorrupted(let context):
            message = "[APIClient] Decoding Error: Data corrupted \n(Context: \(context.debugDescription)) \nCodingKeys: \(context.codingPath)"
        case .typeMismatch(let type, let context):
            message = "[APIClient] Decoding Error: Type mismatch \"\(type)\" \nContext: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            message = "[APIClient] Decoding Error: Value not found, type \"\(type)\" \nContext: \(context.debugDescription)"
        @unknown default:
            message = "[APIClient] Unknown DecodingError catched"
            assertionFailure(message)
        }
        print(message)
    }
}
