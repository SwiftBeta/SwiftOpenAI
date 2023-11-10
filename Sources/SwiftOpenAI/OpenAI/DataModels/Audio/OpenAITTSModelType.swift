import Foundation

public enum OpenAITTSModelType {
    case tts(TTS)
    
    var name: String {
        switch self {
        case .tts(let model):
            return model.rawValue
        }
    }
}

public enum TTS: String {
    case tts1 = "tts-1"
    case tts1HD = "tts-1-hd"
}
