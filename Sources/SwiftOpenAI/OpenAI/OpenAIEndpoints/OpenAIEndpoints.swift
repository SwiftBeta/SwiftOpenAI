import Foundation

enum OpenAIEndpoints {
    case listModels

    case completions(model: OpenAIModelType,
                     optionalParameters: CompletionsOptionalParameters?)

    case chatCompletions(model: OpenAIModelType,
                         messages: [MessageChatGPT],
                         optionalParameters: ChatCompletionsOptionalParameters?)

    case createImage(model: OpenAIImageModelType,
                     prompt: String,
                     numberOfImages: Int,
                     size: ImageSize)

    case embeddings(model: OpenAIModelType, input: String)

    case moderations(input: String)

    public var endpoint: Endpoint {
        switch self {
        case .listModels:
            return ListModelsEndpoint()
        case .completions(model: let model, optionalParameters: let optionalParameters):
            return CompletionsEndpoint(model: model,
                                       optionalParameters: optionalParameters)
        case .chatCompletions(let model, let messages, let optionalParameters):
            return ChatCompletionsEndpoint(model: model,
                                           messages: messages,
                                           optionalParameters: optionalParameters)
        case .createImage(model: let model, prompt: let prompt, numberOfImages: let numberOfImages, size: let size):
            return CreateImageEndpoint(model: model,
                                       prompt: prompt,
                                       numberOfImages: numberOfImages,
                                       size: size)
        case .embeddings(model: let model, input: let input):
            return CreateEmbeddingsEndpoint(model: model,
                                            input: input)
        case .moderations(input: let input):
            return ModerationEndpoint(input: input)
        }
    }
}
