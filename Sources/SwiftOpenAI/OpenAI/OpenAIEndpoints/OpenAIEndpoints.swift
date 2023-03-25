import Foundation

enum OpenAIEndpoints {
    case chatCompletions(model: OpenAIModelType, messages: [MessageChatGPT], optionalParameters: ChatCompletionsOptionalParameters?)
    
    public var endpoint: Endpoint {
        switch self {
        case .chatCompletions(let model, let messages, let optionalParameters):
            return ChatCompletionsEndpoint(model: model,
                                           messages: messages,
                                           optionalParameters: optionalParameters)
        }
    }
}
