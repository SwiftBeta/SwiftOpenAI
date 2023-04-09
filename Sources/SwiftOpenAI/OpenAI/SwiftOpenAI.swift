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
                                     optionalParameters: ChatCompletionsOptionalParameters?)
    async throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error>

    func edits(model: OpenAIModelType,
               input: String,
               instruction: String) async throws -> EditsDataModel?

    func createImages(prompt: String, numberOfImages: Int, size: ImageSize) async throws -> CreateImageDataModel?

    func embeddings(model: OpenAIModelType,
                    input: String) async throws -> EmbeddingResponseDataModel?

    func moderations(input: String) async throws -> ModerationDataModel?
}

// swiftlint:disable line_length
public class SwiftOpenAI: OpenAIProtocol {
    private let api: API
    private let apiKey: String

    private let listModelsRequest: ListModelsRequest.Init
    private let completionsRequest: CompletionsRequest.Init
    private let createChatCompletionsRequest: CreateChatCompletionsRequest.Init
    private let createChatCompletionsStreamRequest: CreateChatCompletionsStreamRequest.Init
    private let editsRequest: EditsRequest.Init
    private let createImagesRequest: CreateImagesRequest.Init
    private let embeddingsRequest: EmbeddingsRequest.Init
    private let moderationsRequest: ModerationsRequest.Init

    public init(api: API = API(),
                apiKey: String,
                listModelsRequest: @escaping ListModelsRequest.Init = ListModelsRequest().execute,
                completionsRequest: @escaping CompletionsRequest.Init = CompletionsRequest().execute,
                createChatCompletionsRequest: @escaping CreateChatCompletionsRequest.Init = CreateChatCompletionsRequest().execute,
                createChatCompletionsStreamRequest: @escaping CreateChatCompletionsStreamRequest.Init = CreateChatCompletionsStreamRequest().execute,
                editsRequest: @escaping EditsRequest.Init = EditsRequest().execute,
                createImagesRequest: @escaping CreateImagesRequest.Init = CreateImagesRequest().execute,
                embeddingsRequest: @escaping EmbeddingsRequest.Init = EmbeddingsRequest().execute,
                moderationsRequest: @escaping ModerationsRequest.Init = ModerationsRequest().execute) {
        self.api = api
        self.apiKey = apiKey
        self.listModelsRequest = listModelsRequest
        self.completionsRequest = completionsRequest
        self.createChatCompletionsRequest = createChatCompletionsRequest
        self.createChatCompletionsStreamRequest = createChatCompletionsStreamRequest
        self.editsRequest = editsRequest
        self.createImagesRequest = createImagesRequest
        self.embeddingsRequest = embeddingsRequest
        self.moderationsRequest = moderationsRequest
    }

    /**
      Retrieves a list of available OpenAI models using the OpenAI API.

      This method uses the OpenAI API to fetch a list of available models. The returned `ModelListDataModel` object contains information about each model, such as its ID, name, and capabilities.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `ModelListDataModel` object containing the list of available OpenAI models. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          do {
              let modelList = try await listModels()
              print(modelList)
          } catch {
              print("Error: \(error)")
          }

    */
    public func listModels() async throws -> ModelListDataModel? {
        try await listModelsRequest(api, apiKey)
    }

    /**
      Generates completions for a given prompt using the OpenAI API with a specified model and optional parameters.

      This method uses the OpenAI API to generate completions for a given prompt using the specified model. You can customize the completion behavior by providing an optional `CompletionsOptionalParameters` object.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Parameters:
        - model: An `OpenAIModelType` value representing the desired OpenAI model to use for generating completions.
        - optionalParameters: An optional `CompletionsOptionalParameters` object containing additional parameters for customizing the completion behavior, such as `maxTokens`, `temperature`, and `n`. If `nil`, the API's default settings will be used.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `CompletionsDataModel` object containing the completions generated by the specified model. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          let prompt = "Once upon a time, in a land far, far away,"
          let optionalParameters = CompletionsOptionalParameters(prompt: prompt, maxTokens: 50, temperature: 0.7, n: 1)
          
          do {
              let completions = try await completions(model: .gpt3_5(.text_davinci_003), optionalParameters: optionalParameters)
              print(completions)
          } catch {
              print("Error: \(error)")
          }

    */
    public func completions(model: OpenAIModelType, optionalParameters: CompletionsOptionalParameters?) async throws -> CompletionsDataModel? {
        try await completionsRequest(api, apiKey, model, optionalParameters)
    }

    /**
      Generates completions for a chat-based conversation using the OpenAI API with a specified model and optional parameters, returning the entire response as a single object.

      This method uses the OpenAI API to generate completions for a chat-based conversation using the specified model. The conversation is represented by an array of `MessageChatGPT` objects. You can customize the completion behavior by providing an optional `ChatCompletionsOptionalParameters` object.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Parameters:
        - model: An `OpenAIModelType` value representing the desired OpenAI model to use for generating chat completions.
        - messages: An array of `MessageChatGPT` objects representing the chat-based conversation.
        - optionalParameters: An optional `ChatCompletionsOptionalParameters` object containing additional parameters for customizing the chat completion behavior, such as `maxTokens`, `temperature`, and `stopPhrases`. If `nil`, the API's default settings will be used.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `ChatCompletionsDataModel` object containing the chat completions generated by the specified model. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          let messages: [MessageChatGPT] = [
             MessageChatGPT(text: "You are a helpful assistant.", role: .system),
             MessageChatGPT(text: "Who won the world series in 2020?", role: .user)
          ]
          let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.7, maxTokens: 50)
          
          do {
              let chatCompletions = try await createChatCompletions(model: .gpt4(.base), messages: messages, optionalParameters: optionalParameters)
              print(chatCompletions)
          } catch {
              print("Error: \(error)")
          }

    */
    public func createChatCompletions(model: OpenAIModelType,
                                      messages: [MessageChatGPT],
                                      optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> ChatCompletionsDataModel? {
        try await createChatCompletionsRequest(api, apiKey, model, messages, optionalParameters)
    }

    /**
      Generates completions for a chat-based conversation using the OpenAI API with a specified model and optional parameters, returning an asynchronous throwing stream of responses.

      This method uses the OpenAI API to generate completions for a chat-based conversation using the specified model. The conversation is represented by an array of `MessageChatGPT` objects. You can customize the completion behavior by providing an optional `ChatCompletionsOptionalParameters` object with the `useStream` property set to `true`.

      The method makes use of the new Swift concurrency model and supports async/await calls, providing an `AsyncThrowingStream` of `ChatCompletionsStreamDataModel` objects for processing the stream of generated completions.

      - Parameters:
        - model: An `OpenAIModelType` value representing the desired OpenAI model to use for generating chat completions.
        - messages: An array of `MessageChatGPT` objects representing the chat-based conversation.
        - optionalParameters: An optional `ChatCompletionsOptionalParameters` object containing additional parameters for customizing the chat completion behavior, such as `maxTokens`, `temperature`, `useStream`, and `stopPhrases`. If `nil`, the API's default settings will be used.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An `AsyncThrowingStream<ChatCompletionsStreamDataModel, Error>` representing the asynchronous stream of chat completions generated by the specified model.

      Example usage:

            let messages: [MessageChatGPT] = [
               MessageChatGPT(text: "You are a helpful assistant.", role: .system),
               MessageChatGPT(text: "Who won the world series in 2020?", role: .user)
             ]
             let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.7, stream: true, maxTokens: 50)

             do {
                 let stream = try await createChatCompletionsStream(model: .gpt4(.base), messages: messages, optionalParameters: optionalParameters)
                 
                 for try await response in stream {
                     print(response)
                 }
             } catch {
                 print("Error: \(error)")
             }
    */
    public func createChatCompletionsStream(model: OpenAIModelType,
                                            messages: [MessageChatGPT],
                                            optionalParameters: ChatCompletionsOptionalParameters? = nil) async throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error> {
        try createChatCompletionsStreamRequest(api, apiKey, model, messages, optionalParameters)
    }

    /**
      Generates suggested edits for a given input string based on a provided instruction using the specified OpenAI model.

      This method uses the OpenAI API to generate suggested edits for a given input string based on a provided instruction using the specified model. The edits can be used for tasks such as proofreading or content modification.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Parameters:
        - model: An `OpenAIModelType` value representing the desired OpenAI model to use for generating suggested edits.
        - input: A `String` representing the input text for which suggested edits will be generated.
        - instruction: A `String` representing the instruction that guides the editing process.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `EditsDataModel` object containing the suggested edits for the given input based on the provided instruction. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          let inputText = "The car have four weels."
          let instruction = "Please correct any grammatical errors in the text."
          
          do {
              let edits = try await edits(model: .edit(.text_davinci_edit_001), input: inputText, instruction: instruction)
              print(edits)
          } catch {
              print("Error: \(error)")
          }

    */
    public func edits(model: OpenAIModelType,
                      input: String,
                      instruction: String) async throws -> EditsDataModel? {
        try await editsRequest(api, apiKey, model, input, instruction)
    }

    /**
      Generates images based on a given prompt using the OpenAI DALL-E 2 API.

      This method uses the OpenAI DALL-E 2 API to generate images based on a given prompt. You can specify the number of images you want to generate and the size of the generated images.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Parameters:
        - prompt: A `String` representing the prompt text to be used for generating images.
        - numberOfImages: An `Int` representing the number of images to be generated.
        - size: An `ImageSize` value representing the desired size of the generated images.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `CreateImageDataModel` object containing the generated images for the given prompt. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          let promptText = "A beautiful sunset over the ocean."
          let numberOfImages = 4
          let imageSize: ImageSize = .s1024
          
          do {
              let images = try await createImages(prompt: promptText, numberOfImages: numberOfImages, size: imageSize)
              print(images)
          } catch {
              print("Error: \(error)")
          }

    */
    public func createImages(prompt: String, numberOfImages: Int, size: ImageSize) async throws -> CreateImageDataModel? {
        try await createImagesRequest(api, apiKey, prompt, numberOfImages, size)
    }

    /**
      Generates embeddings for a given input string using the specified OpenAI model.

      This method uses the OpenAI API to generate embeddings for a given input string using the specified model. The embeddings can be used for various natural language processing tasks, such as clustering, similarity calculations, or as input for other machine learning models.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Parameters:
        - model: An `OpenAIModelType` value representing the desired OpenAI model to use for generating embeddings.
        - input: A `String` representing the input text for which embeddings will be generated.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `EmbeddingResponseDataModel` object containing the generated embeddings for the given input. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          let inputText = "Embeddings are a numerical representation of text."
          
          do {
              let embeddings = try await embeddings(model: .embedding(.text_embedding_ada_002), input: inputText)
              print(embeddings)
          } catch {
              print("Error: \(error)")
          }
    */
    public func embeddings(model: OpenAIModelType, input: String) async throws -> EmbeddingResponseDataModel? {
        try await embeddingsRequest(api, apiKey, model, input)
    }

    /**
      Moderates the content of a given input string using a moderation API.

      This method uses the moderation API to analyze and moderate the content of a given input string. The analysis includes detecting and categorizing potentially harmful, inappropriate or explicit content within the input text. The moderation results can be used for content filtering, user behavior analysis, or other moderation purposes.

      The method makes use of the new Swift concurrency model and supports async/await calls.

      - Parameters:
        - input: A `String` representing the input text to be moderated.

      - Throws: An error if the API call fails, or if there is a problem with parsing the received JSON data.

      - Returns: An optional `ModerationDataModel` object containing the moderation results for the given input. Returns `nil` if there was an issue fetching the data or parsing the JSON response.

      Example usage:

          let inputText = "Some potentially harmful or explicit content."

          do {
              let moderationResults = try await moderations(input: inputText)
              print(moderationResults)
          } catch {
              print("Error: \(error)")
          }
    */
    public func moderations(input: String) async throws -> ModerationDataModel? {
        try await moderationsRequest(api, apiKey, input)
    }
}
// swiftlint:enable line_length
