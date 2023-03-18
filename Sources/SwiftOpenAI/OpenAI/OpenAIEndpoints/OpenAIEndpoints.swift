import Foundation

enum OpenAIEndpoints {
    case chat(model: OpenAIModelType, messages: [MessageChatGPT])
    
    public var endpoint: Endpoint {
        switch self {
        case .chat(let model, let messages):
            return ChatCompletionsEndpoint(model: model, messages: messages)
        }
    }
}
