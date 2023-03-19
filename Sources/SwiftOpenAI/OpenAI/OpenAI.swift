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
    
    public init(api: API,
         apiKey: String,
         createChatCompletionsRequest: @escaping CreateChatCompletionsRequest.Init = CreateChatCompletionsRequest().execute) {
        self.api = api
        self.apiKey = apiKey
        self.createChatCompletionsRequest = createChatCompletionsRequest
    }
    
    public func createChatCompletions(model: OpenAIModelType,
                                     messages: [MessageChatGPT],
                                     optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> ChatCompletionsDataModel? {
        try await createChatCompletionsRequest(api, apiKey, model, messages, optionalParameters)
    }
}
