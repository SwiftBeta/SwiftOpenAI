import Foundation

enum OpenAIEndpoints {
    case chatCompletions(model: OpenAIModelType,
                         messages: [MessageChatGPT],
                         optionalParameters: ChatCompletionsOptionalParameters?)
    case createImage(prompt: String,
                     numberOfImages: Int,
                     size: ImageSize)
    
    public var endpoint: Endpoint {
        switch self {
        case .chatCompletions(let model, let messages, let optionalParameters):
            return ChatCompletionsEndpoint(model: model,
                                           messages: messages,
                                           optionalParameters: optionalParameters)
        case .createImage(prompt: let prompt, numberOfImages: let numberOfImages, size: let size):
            return CreateImageEndpoint(prompt: prompt, numberOfImages: numberOfImages, size: size)
        }
    }
}
