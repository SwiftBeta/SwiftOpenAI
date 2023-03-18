import Foundation

public protocol RequesterProtocol {
    func execute(with urlRequest: URLRequest) async -> Result<Data, Error>
}

final public class Requester: RequesterProtocol {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func execute(with urlRequest: URLRequest) async -> Result<Data, Error> {
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return .success(data)
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
}
