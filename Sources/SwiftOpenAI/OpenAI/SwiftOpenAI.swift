import Foundation

protocol OpenAIProtocol {
    func listModels() async throws -> ModelListDataModel?
    
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
    
    func embeddings(model: OpenAIModelType,
                    input: String) async throws -> EmbeddingResponseDataModel?
}

public class SwiftOpenAI: OpenAIProtocol {
    private let api: API
    private let apiKey: String
    
    private let listModelsRequest: ListModelsRequest.Init
    private let completionsRequest: CompletionsRequest.Init
    private let createChatCompletionsRequest: CreateChatCompletionsRequest.Init
    private let createChatCompletionsStreamRequest: CreateChatCompletionsStreamRequest.Init
    private let editsRequest: EditsRequest.Init
    private let createImagesRequest: CreateImagesRequest.Init
    private let embeddingRequest: EmbeddingsRequest.Init
    
    public init(api: API = API(),
                apiKey: String,
                listModelsRequest: @escaping ListModelsRequest.Init = ListModelsRequest().execute,
                completionsRequest: @escaping CompletionsRequest.Init = CompletionsRequest().execute,
                createChatCompletionsRequest: @escaping CreateChatCompletionsRequest.Init = CreateChatCompletionsRequest().execute,
                createChatCompletionsStreamRequest: @escaping CreateChatCompletionsStreamRequest.Init = CreateChatCompletionsStreamRequest().execute,
                editsRequest: @escaping EditsRequest.Init = EditsRequest().execute,
                createImagesRequest: @escaping CreateImagesRequest.Init = CreateImagesRequest().execute,
                embeddingRequest: @escaping EmbeddingsRequest.Init = EmbeddingsRequest().execute) {
        self.api = api
        self.apiKey = apiKey
        self.listModelsRequest = listModelsRequest
        self.completionsRequest = completionsRequest
        self.createChatCompletionsRequest = createChatCompletionsRequest
        self.createChatCompletionsStreamRequest = createChatCompletionsStreamRequest
        self.editsRequest = editsRequest
        self.createImagesRequest = createImagesRequest
        self.embeddingRequest = embeddingRequest
    }
    
    public func listModels() async throws -> ModelListDataModel? {
        try await listModelsRequest(api, apiKey)
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
    
    public func embeddings(model: OpenAIModelType, input: String) async throws -> EmbeddingResponseDataModel? {
        try await embeddingRequest(api, apiKey, model, input)
    }
}
