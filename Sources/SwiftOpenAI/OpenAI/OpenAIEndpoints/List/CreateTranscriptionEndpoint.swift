import Foundation

struct CreateTranscriptionEndpoint: Endpoint {
    private let file: Data
    private let model: OpenAITranscriptionModelType
    private let language: String
    private let prompt: String
    private let responseFormat: OpenAIAudioResponseType
    private let temperature: Double
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String = "audio/transcriptions"
    
    init(file: Data,
         model: OpenAITranscriptionModelType,
         language: String = "en",
         prompt: String = "",
         responseFormat: OpenAIAudioResponseType,
         temperature: Double = 0.0) {
        self.file = file
        self.model = model
        self.language = language
        self.prompt = prompt
        self.responseFormat = responseFormat
        self.temperature = temperature
    }
    
    var parameters: [String: Any]? {
        ["model": self.model.rawValue as Any,
         "language": self.language as Any,
         "prompt": self.prompt as Any,
         "response_format": self.responseFormat.rawValue as Any,
         "temperature": self.temperature as Any]
    }
}
