import Foundation

enum OpenAIEndpoints {
    case chat(model: OpenAIModelType, messages: [MessageChatGPT], optionalParameters: ChatCompletionsOptionalParameters?)
    
    public var endpoint: Endpoint {
        switch self {
        case .chat(let model, let messages, let optionalParameters):
            return ChatCompletionsEndpoint(model: model,
                                           messages: messages,
                                           optionalParameters: optionalParameters)
        }
    }
}
