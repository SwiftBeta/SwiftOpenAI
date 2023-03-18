import Foundation.NSURLSession
@testable import SwiftOpenAI

struct RequesterMock: RequesterProtocol {
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }
    
    func execute(with urlRequest: URLRequest) async -> Result<Data, Error> {
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return .success(data)
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
}
