import Foundation

protocol CompletionsRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAIModelType,
                 optionalParameters: CompletionsOptionalParameters?) async throws -> CompletionsDataModel?
}

final public class CompletionsRequest: CompletionsRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIModelType,
                             _ optionalParameters: CompletionsOptionalParameters?) async throws -> CompletionsDataModel?

    public init() { }

    public func execute(api: API,
                        apiKey: String,
                        model: OpenAIModelType,
                        optionalParameters: CompletionsOptionalParameters?) async throws -> CompletionsDataModel? {
        var endpoint = OpenAIEndpoints.completions(model: model, optionalParameters: optionalParameters).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try api.parse(result,
                             type: CompletionsDataModel.self,
                             jsonDecoder: jsonDecoder,
                             errorType: OpenAIAPIError.self)
    }
}
