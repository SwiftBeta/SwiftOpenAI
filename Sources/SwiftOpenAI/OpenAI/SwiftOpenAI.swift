import Foundation

protocol OpenAIProtocol {
    func completions(model: OpenAIModelType,
                     optionalParameters: CompletionsOptionalParameters?) async throws -> CompletionsDataModel?
    
    func createChatCompletions(model: OpenAIModelType,
                               messages: [MessageChatGPT],
                               optionalParameters: ChatCompletionsOptionalParameters?) async throws -> ChatCompletionsDataModel?
    
    func createChatCompletionsStream(model: OpenAIModelType,
                                     messages: [MessageChatGPT],
                                     optionalParameters: ChatCompletionsOptionalParameters?) async throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error>
    
    func edits(model: OpenAIModelType,
               input: String,
               instruction: String) async throws -> EditsDataModel?
    
    func createImages(prompt: String, numberOfImages: Int, size: ImageSize) async throws -> CreateImageDataModel?
}

public class SwiftOpenAI: OpenAIProtocol {
    private let api: API
    private let apiKey: String
    
    private let completionsRequest: CompletionsRequest.Init
    private let createChatCompletionsRequest: CreateChatCompletionsRequest.Init
    private let createChatCompletionsStreamRequest: CreateChatCompletionsStreamRequest.Init
    private let editsRequest: EditsRequest.Init
    private let createImagesRequest: CreateImagesRequest.Init
    
    public init(api: API = API(),
                apiKey: String,
                completionsRequest: @escaping CompletionsRequest.Init = CompletionsRequest().execute,
                createChatCompletionsRequest: @escaping CreateChatCompletionsRequest.Init = CreateChatCompletionsRequest().execute,
                createChatCompletionsStreamRequest: @escaping CreateChatCompletionsStreamRequest.Init = CreateChatCompletionsStreamRequest().execute,
                editsRequest: @escaping EditsRequest.Init = EditsRequest().execute,
                createImagesRequest: @escaping CreateImagesRequest.Init = CreateImagesRequest().execute) {
        self.api = api
        self.apiKey = apiKey
        self.completionsRequest = completionsRequest
        self.createChatCompletionsRequest = createChatCompletionsRequest
        self.createChatCompletionsStreamRequest = createChatCompletionsStreamRequest
        self.editsRequest = editsRequest
        self.createImagesRequest = createImagesRequest
    }
    
    public func completions(model: OpenAIModelType, optionalParameters: CompletionsOptionalParameters?) async throws -> CompletionsDataModel? {
        try await completionsRequest(api, apiKey, model, optionalParameters)
    }
    
    public func createChatCompletions(model: OpenAIModelType,
                                      messages: [MessageChatGPT],
                                      optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> ChatCompletionsDataModel? {
        try await createChatCompletionsRequest(api, apiKey, model, messages, optionalParameters)
    }
    
    public func createChatCompletionsStream(model: OpenAIModelType,
                                            messages: [MessageChatGPT],
                                            optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error> {
        try createChatCompletionsStreamRequest(api, apiKey, model, messages, optionalParameters)
    }
    
    public func edits(model: OpenAIModelType,
                      input: String,
                      instruction: String) async throws -> EditsDataModel? {
        try await editsRequest(api, apiKey, model, input, instruction)
    }
    
    public func createImages(prompt: String, numberOfImages: Int, size: ImageSize) async throws -> CreateImageDataModel? {
        try await createImagesRequest(api, apiKey, prompt, numberOfImages, size)
    }
}
