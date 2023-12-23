import Foundation
import Foundation

protocol CreateChatCompletionsImageInputRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAIModelType,
                 messages: [MessageChatImageInput],
                 optionalParameters: ChatCompletionsOptionalParameters?) async throws -> ChatCompletionsDataModel?
}

final public class CreateChatCompletionsImageInputRequest: CreateChatCompletionsImageInputRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIModelType,
                             _ messages: [MessageChatImageInput],
                             _ optionalParameters: ChatCompletionsOptionalParameters?) async throws -> ChatCompletionsDataModel?

    public init() { }

    public func execute(api: API,
                        apiKey: String,
                        model: OpenAIModelType,
                        messages: [MessageChatImageInput],
                        optionalParameters: ChatCompletionsOptionalParameters?) async throws -> ChatCompletionsDataModel? {
        var endpoint = OpenAIEndpoints.chatCompletionsWithImageInput(model: model, messages: messages, optionalParameters: optionalParameters).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try api.parse(result,
                             type: ChatCompletionsDataModel.self,
                             jsonDecoder: jsonDecoder,
                             errorType: OpenAIAPIError.self)
    }
}
