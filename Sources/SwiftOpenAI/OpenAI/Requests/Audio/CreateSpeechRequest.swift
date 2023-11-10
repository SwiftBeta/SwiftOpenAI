import Foundation

protocol CreateSpeechRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAITTSModelType,
                 input: String,
                 voice: OpenAIVoiceType,
                 responseFormat: OpenAIAudioResponseType,
                 speed: Double) async throws -> Data?
}

final public class CreateSpeechRequest: CreateSpeechRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAITTSModelType,
                             _ input: String,
                             _ voice: OpenAIVoiceType,
                             _ responseFormat: OpenAIAudioResponseType,
                             _ speed: Double) async throws -> Data?

    public init() { }

    public func execute(api: API,
                        apiKey: String,
                        model: OpenAITTSModelType,
                        input: String,
                        voice: OpenAIVoiceType,
                        responseFormat: OpenAIAudioResponseType,
                        speed: Double) async throws -> Data? {
        var endpoint = OpenAIEndpoints.createSpeech(model: model, input: input, voice: voice, responseFormat: responseFormat, speed: speed).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
