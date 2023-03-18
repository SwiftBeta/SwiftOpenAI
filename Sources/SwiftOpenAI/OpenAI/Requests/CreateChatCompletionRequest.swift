import Foundation

protocol CreateChatCompletionRequestProtocol {
    func execute(api: API, apiKey: String, model: OpenAIModelType, messages: [MessageChatGPT]) async -> ChatCompletionDataModel?
}

final public class CreateChatCompletionRequest: CreateChatCompletionRequestProtocol  {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIModelType,
                             _ messages: [MessageChatGPT]) async -> ChatCompletionDataModel?
    
    public init() { }
    
    public func execute(api: API,
                 apiKey: String,
                 model: OpenAIModelType,
                 messages: [MessageChatGPT]) async -> ChatCompletionDataModel? {
        var endpoint = OpenAIEndpoints.chat(model: model, messages: messages).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())
        
        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type" : "application/json",
                                 "Authorization" : "Bearer \(apiKey)"])
        
        let result = await api.execute(with: urlRequest)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try? api.parse(result,
                              type: ChatCompletionDataModel.self,
                              jsonDecoder: jsonDecoder)
    }
}
