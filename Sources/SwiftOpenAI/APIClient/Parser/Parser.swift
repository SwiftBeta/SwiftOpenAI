import Foundation

public protocol ParserProtocol {
    func parse<T: Decodable>(_ data: Result<Data, Error>, type: T.Type, jsonDecoder: JSONDecoder) throws -> T?
    func parse<T: Decodable>(_ data: Data, type: T.Type, jsonDecoder: JSONDecoder) throws -> T?
}

final public class Parser: ParserProtocol {
    public init() { }
    
    public func parse<T: Decodable>(_ result: Result<Data, Error>,
                                    type: T.Type,
                                    jsonDecoder: JSONDecoder = .init()) throws -> T? {
        switch result {
        case .success(let data):
            let dataModel = try parse(data, type: T.self, jsonDecoder: jsonDecoder)
            return dataModel
        case .failure(let error):
            print("[APIClient] Error: \(error)")
            throw error
        }
    }
    
    public func parse<T: Decodable>(_ data: Data,
                                    type: T.Type,
                                    jsonDecoder: JSONDecoder = .init()) throws -> T? {
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            print("[APIClient] JSON: \(json)")
            return try jsonDecoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            printDecodable(error: error)
            throw error
        }
    }
}

extension Parser {
    func printDecodable(error: Error) {
        guard let error = error as? DecodingError else {
            print("[APIClient] Error: \(error)")
            return
        }
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
