import Foundation

public protocol RequestBuilderProtocol {
    func buildURLRequest(endpoint: Endpoint) -> URLRequest
    func addHeaders(urlRequest: inout URLRequest, headers: [String: String])
}

final public class RequestBuilder: RequestBuilderProtocol {

    public init() { }

    public func buildURLRequest(endpoint: Endpoint) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: endpoint.path)!)
        urlRequest.httpMethod = endpoint.method.rawValue

        switch endpoint.method {
        case .POST:
            guard let parameters = endpoint.parameters,
                  !parameters.isEmpty,
                  let postData = (try? JSONSerialization.data(withJSONObject: parameters,
                                                              options: [])) else {
                      return urlRequest
                  }
            urlRequest.httpBody = postData
        case .GET:
            guard let parameters = endpoint.parameters else {
                return urlRequest
            }
            var urlComponents = URLComponents(string: endpoint.path)
            urlComponents?.queryItems = parameters.map({ key, value in
                URLQueryItem(name: key, value: value as? String)
            })
            urlRequest.url = urlComponents?.url
        }

        return urlRequest
    }

    public func addHeaders(urlRequest: inout URLRequest, headers: [String: String]) {
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
