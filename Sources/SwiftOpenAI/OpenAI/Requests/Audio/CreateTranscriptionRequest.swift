import Foundation

protocol CreateTranscriptionRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 file: Data,
                 model: OpenAITranscriptionModelType,
                 language: String,
                 prompt: String,
                 responseFormat: OpenAIAudioResponseType,
                 temperature: Double) async throws -> AsyncThrowingStream<CreateTranscriptionDataModel, Error>
}

final public class CreateTranscriptionRequest: NSObject, CreateTranscriptionRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ file: Data,
                             _ model: OpenAITranscriptionModelType,
                             _ language: String,
                             _ prompt: String,
                             _ responseFormat: OpenAIAudioResponseType,
                             _ temperature: Double) async throws -> AsyncThrowingStream<CreateTranscriptionDataModel, Error>
    
    private var urlSession: URLSession?
    private var dataTask: URLSessionDataTask?
    private var continuation: AsyncThrowingStream<CreateTranscriptionDataModel, Error>.Continuation?
    
    public override init() {
        super.init()
    }
    
    public func execute(api: API,
                        apiKey: String,
                        file: Data,
                        model: OpenAITranscriptionModelType,
                        language: String,
                        prompt: String,
                        responseFormat: OpenAIAudioResponseType,
                        temperature: Double) async throws -> AsyncThrowingStream<CreateTranscriptionDataModel, Error> {
        
        return AsyncThrowingStream<CreateTranscriptionDataModel, Error> { continuation in
            self.continuation = continuation
            
            var endpoint = OpenAIEndpoints.createTranscription(file: file, model: model, language: language, prompt: prompt, responseFormat: responseFormat, temperature: temperature).endpoint
            api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())
            
            let boundary = UUID().uuidString
            
            var urlRequest = api.buildURLRequest(endpoint: endpoint)
            api.addHeaders(urlRequest: &urlRequest,
                           headers: ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                                     "Authorization": "Bearer \(apiKey)"])
            
            var body = Data()
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
            body.append("whisper-1\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"steve.mp4\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)
            body.append(file)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = body
            
            self.urlSession = URLSession(configuration: .default,
                                         delegate: self,
                                         delegateQueue: OperationQueue())
            
            dataTask = urlSession?.dataTask(with: urlRequest)
            dataTask?.resume()
        }
    }
}

extension CreateTranscriptionRequest: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let createTranscriptionDataModel = try JSONDecoder().decode(CreateTranscriptionDataModel.self, from: data)
            self.continuation?.yield(createTranscriptionDataModel)
        } catch {
            print("Error al parsear JSON:", error.localizedDescription)
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
