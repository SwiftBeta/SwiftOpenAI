import Foundation

protocol ModerationsRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 input: String) async throws -> ModerationDataModel?
}

final public class ModerationsRequest: ModerationsRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ input: String) async throws -> ModerationDataModel?

    public init() { }

    public func execute(api: API,
                        apiKey: String,
                        input: String) async throws -> ModerationDataModel? {
        var endpoint = OpenAIEndpoints.moderations(input: input).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try api.parse(result,
                             type: ModerationDataModel.self,
                             jsonDecoder: jsonDecoder,
                             errorType: OpenAIAPIError.self)
    }
}
