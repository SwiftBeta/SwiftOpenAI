import Foundation

protocol EmbeddingsRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAIModelType,
                 input: String) async throws -> EmbeddingResponseDataModel?
}

final public class EmbeddingsRequest: EmbeddingsRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIModelType,
                             _ input: String) async throws -> EmbeddingResponseDataModel?

    public init() { }

    public func execute(api: API,
                        apiKey: String,
                        model: OpenAIModelType,
                        input: String) async throws -> EmbeddingResponseDataModel? {
        var endpoint = OpenAIEndpoints.embeddings(model: model, input: input).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try api.parse(result,
                             type: EmbeddingResponseDataModel.self,
                             jsonDecoder: jsonDecoder,
                             errorType: OpenAIAPIError.self)
    }
}
