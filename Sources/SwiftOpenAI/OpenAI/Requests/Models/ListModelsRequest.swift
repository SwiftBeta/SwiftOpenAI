import Foundation

protocol ListModelsRequestProtocol {
    func execute(api: API,
                 apiKey: String) async throws -> ModelListDataModel?
}

final public class ListModelsRequest: ListModelsRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String) async throws -> ModelListDataModel?

    public init() { }

    public func execute(api: API,
                        apiKey: String) async throws -> ModelListDataModel? {
        var endpoint = OpenAIEndpoints.listModels.endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try api.parse(result,
                             type: ModelListDataModel.self,
                             jsonDecoder: jsonDecoder,
                             errorType: OpenAIAPIError.self)
    }
}
