import XCTest
@testable import SwiftOpenAI

final class CreateSpeechEndpointSpec: XCTestCase {
    func testEndpointCreateSpeech_WithModelTTS() throws {
        let model: OpenAITTSModelType = .tts(.tts1)
        let input = "Please create an audio with this input"
        let voice: OpenAIVoiceType = .alloy
        let responseFormat: OpenAIAudioResponseType = .mp3
        let speed = 1.0
        
        let sut = OpenAIEndpoints.createSpeech(
            model: model,
            input: input,
            voice: voice,
            responseFormat: responseFormat,
            speed: speed
        ).endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let inputParameter = sut.parameters!["input"] as! String
        let voiceParameter = sut.parameters!["voice"] as! String
        let responseFormatParameter = sut.parameters!["response_format"] as! String
        let speedFormatParameter = sut.parameters!["speed"] as! Double
        
        XCTAssertEqual(sut.path, "audio/speech")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 5)
        XCTAssertEqual(modelParameter, model.name)
        XCTAssertEqual(inputParameter, input)
        XCTAssertEqual(voiceParameter, voice.rawValue)
        XCTAssertEqual(responseFormatParameter, responseFormat.rawValue)
        XCTAssertEqual(speedFormatParameter, speed)
    }
}

