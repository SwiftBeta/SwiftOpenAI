import Foundation

// swiftlint:disable line_length
protocol CreateChatCompletionsStreamRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAIModelType,
                 messages: [MessageChatGPT],
                 optionalParameters: ChatCompletionsOptionalParameters?) throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error>
    func setURLSession(urlSession: URLSession)
}

final public class CreateChatCompletionsStreamRequest: NSObject, CreateChatCompletionsStreamRequestProtocol {

    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIModelType,
                             _ messages: [MessageChatGPT],
                             _ optionalParameters: ChatCompletionsOptionalParameters?) throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error>

    private var urlSession: URLSession?
    private var dataTask: URLSessionDataTask?
    private var streamMapper: ChatCompletionsStreamMappeable
    private var continuation: AsyncThrowingStream<ChatCompletionsStreamDataModel, Error>.Continuation?

    public init(streamMapper: ChatCompletionsStreamMappeable = ChatCompletionsStreamMapper()) {
        self.streamMapper = streamMapper
        super.init()
        self.urlSession = URLSession(configuration: .default,
                               delegate: self,
                               delegateQueue: OperationQueue())
    }

    public func execute(api: API,
                        apiKey: String,
                        model: OpenAIModelType,
                        messages: [MessageChatGPT],
                        optionalParameters: ChatCompletionsOptionalParameters?) throws -> AsyncThrowingStream<ChatCompletionsStreamDataModel, Error> {
        return AsyncThrowingStream<ChatCompletionsStreamDataModel, Error> { continuation in
            self.continuation = continuation
            var endpoint = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: optionalParameters).endpoint
            api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

            var urlRequest = api.buildURLRequest(endpoint: endpoint)
            api.addHeaders(urlRequest: &urlRequest,
                           headers: ["Content-Type": "application/json",
                                     "Authorization": "Bearer \(apiKey)"])

            dataTask = urlSession?.dataTask(with: urlRequest)
            dataTask?.resume()
        }
    }

    func setURLSession(urlSession: URLSession) {
        self.urlSession = urlSession
    }
}
// swiftlint:enable line_length

extension CreateChatCompletionsStreamRequest: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            try streamMapper.parse(data: data).forEach { [weak self] newMessage in
                self?.continuation?.yield(newMessage)
            }
        } catch {
            continuation?.finish(throwing: error)
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            continuation?.finish()
            return
        }
        continuation?.finish(throwing: error)
    }
}
