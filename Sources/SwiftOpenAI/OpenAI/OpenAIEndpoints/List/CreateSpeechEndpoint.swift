import Foundation

struct CreateSpeechEndpoint: Endpoint {
    private let model: OpenAITTSModelType
    private let input: String
    private let voice: OpenAIVoiceType
    private let responseFormat: OpenAIAudioResponseType
    private let speed: Double
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String = "audio/speech"
    
    init(model: OpenAITTSModelType,
         input: String,
         voice: OpenAIVoiceType,
         responseFormat: OpenAIAudioResponseType,
         speed: Double) {
        self.model = model
        self.input = input
        self.voice = voice
        self.responseFormat = responseFormat
        self.speed = speed
    }
    
    var parameters: [String: Any]? {
        ["model": self.model.name as Any,
         "input": self.input as Any,
         "voice": self.voice.rawValue as Any,
         "response_format": self.responseFormat.rawValue as Any,
         "speed": self.speed as Any]
    }
}
