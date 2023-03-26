import Foundation

protocol OpenAIProtocol {
    func createChatCompletions(model: OpenAIModelType,
                              messages: [MessageChatGPT],
                              optionalParameters: ChatCompletionsOptionalParameters?) async throws -> ChatCompletionsDataModel?
}

public class SwiftOpenAI: OpenAIProtocol {
    private let api: API
    private let apiKey: String
    
    private let createChatCompletionsRequest: CreateChatCompletionsRequest.Init
    private let createChatCompletionsStreamRequest: CreateChatCompletionsStreamRequest.Init
    
    public init(api: API = API(),
                apiKey: String,
                createChatCompletionsRequest: @escaping CreateChatCompletionsRequest.Init = CreateChatCompletionsRequest().execute,
                createChatCompletionsStreamRequest: @escaping CreateChatCompletionsStreamRequest.Init = CreateChatCompletionsStreamRequest().execute) {
        self.api = api
        self.apiKey = apiKey
        self.createChatCompletionsRequest = createChatCompletionsRequest
        self.createChatCompletionsStreamRequest = createChatCompletionsStreamRequest
    }
    
    public func createChatCompletions(model: OpenAIModelType,
                                     messages: [MessageChatGPT],
                                     optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> ChatCompletionsDataModel? {
        try await createChatCompletionsRequest(api, apiKey, model, messages, optionalParameters)
    }
    
    public func createChatCompletionsStream(model: OpenAIModelType,
                                            messages: [MessageChatGPT],
                                            optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error> {
        return try createChatCompletionsStreamRequest(api, apiKey, model, messages, optionalParameters)
    }
}
