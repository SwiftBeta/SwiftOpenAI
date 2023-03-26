import Foundation.NSURLSession
@testable import SwiftOpenAI

struct RequesterMock: RequesterProtocol {
    var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }()
    
    func execute(with urlRequest: URLRequest) async -> Result<Data, APIError> {
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
