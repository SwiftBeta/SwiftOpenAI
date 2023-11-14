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

    case createSpeech(model: OpenAITTSModelType, input: String, voice: OpenAIVoiceType, responseFormat: OpenAIAudioResponseType, speed: Double)
    
    case createTranscription(file: Data, model: OpenAITranscriptionModelType, language: String, prompt: String, responseFormat: OpenAIAudioResponseType, temperature: Double)

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
        case .createSpeech(model: let model, input: let input, voice: let voice, responseFormat: let responseFormat, speed: let speed):
            return CreateSpeechEndpoint(model: model, 
                                        input: input,
                                        voice: voice,
                                        responseFormat: responseFormat,
                                        speed: speed)
        case .createTranscription(file: let file, model: let model, language: let language, prompt: let prompt, responseFormat: let responseFormat, temperature: let temperature):
            return CreateTranscriptionEndpoint(file: file, 
                                               model: model, 
                                               language: language, 
                                               prompt: prompt, 
                                               responseFormat: responseFormat, 
                                               temperature: temperature)
        }
    }
}
