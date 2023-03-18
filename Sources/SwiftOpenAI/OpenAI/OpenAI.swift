import Foundation

protocol OpenAIProtocol {
    func createChatCompletion(model: OpenAIModelType, messages: [MessageChatGPT]) async -> ChatCompletionDataModel?
}

public class OpenAI: OpenAIProtocol {
    private let api: API
    private let apiKey: String
    
    private let createChatCompletionRequest: CreateChatCompletionRequest.Init
    
    public init(api: API,
         apiKey: String,
         createChatCompletionRequest: @escaping CreateChatCompletionRequest.Init = CreateChatCompletionRequest().execute) {
        self.api = api
        self.apiKey = apiKey
        self.createChatCompletionRequest = createChatCompletionRequest
    }
    
    public func createChatCompletion(model: OpenAIModelType,
                                     messages: [MessageChatGPT]) async -> ChatCompletionDataModel? {
        await createChatCompletionRequest(api, apiKey, model, messages)
    }
}
