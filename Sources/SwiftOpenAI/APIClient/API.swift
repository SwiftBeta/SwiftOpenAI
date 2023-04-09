import Foundation

public final class API {
    private let requester: RequesterProtocol
    private let parser: ParserProtocol
    private let router: RouterProtocol
    private let requestBuilder: RequestBuilderProtocol

    public init(requester: RequesterProtocol = Requester(),
                parser: ParserProtocol = Parser(),
                router: RouterProtocol = Router(),
                requestBuilder: RequestBuilderProtocol = RequestBuilder()) {
        self.requester = requester
        self.parser = parser
        self.router = router
        self.requestBuilder = requestBuilder
    }

    public func routeEndpoint(_ endpoint: inout Endpoint, environment: BaseEnvironmentType) {
        router.routeEndpoint(&endpoint, environment: environment)
    }

    public func buildURLRequest(endpoint: Endpoint) -> URLRequest {
        requestBuilder.buildURLRequest(endpoint: endpoint)
    }

    public func addHeaders(urlRequest: inout URLRequest, headers: [String: String]) {
        requestBuilder.addHeaders(urlRequest: &urlRequest, headers: headers)
    }

    public func execute(with urlRequest: URLRequest) async -> Result<Data, APIError> {
        await requester.execute(with: urlRequest)
    }

    public func parse<T: Decodable, E: Decodable & Error>(_ data: Result<Data, APIError>, type: T.Type, jsonDecoder: JSONDecoder, errorType: E.Type) throws -> T? {
        try parser.parse(data, type: T.self, jsonDecoder: jsonDecoder, errorType: E.self)
    }
}
