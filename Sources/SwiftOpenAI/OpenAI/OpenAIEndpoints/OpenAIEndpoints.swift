import Foundation

enum OpenAIEndpoints {
    case listModels

    case completions(model: OpenAIModelType,
                     optionalParameters: CompletionsOptionalParameters?)

    case chatCompletions(model: OpenAIModelType,
                         messages: [MessageChatGPT],
                         optionalParameters: ChatCompletionsOptionalParameters?)

    case edits(model: OpenAIModelType,
               input: String,
               instruction: String)

    case createImage(prompt: String,
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
        case .edits(model: let model, input: let input, instruction: let instruction):
            return EditsEndpoint(model: model,
                                 input: input,
                                 instruction: instruction)
        case .createImage(prompt: let prompt, numberOfImages: let numberOfImages, size: let size):
            return CreateImageEndpoint(prompt: prompt,
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
