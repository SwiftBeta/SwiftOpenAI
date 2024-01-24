import XCTest
@testable import SwiftOpenAI

final class CreateTranscriptionEndpointSpec: XCTestCase {
    func testEndpointCreateSpeech_WithModelTTS() throws {
        let model: OpenAITranscriptionModelType = .whisper
        let language = "en"
        let responseFormat: OpenAIAudioResponseType = .mp3
        let temperature = 1.0
        
        let sut = OpenAIEndpoints.createTranscription(
            file: Data(),
            model: model,
            language: language,
            prompt: "",
            responseFormat: responseFormat,
            temperature: temperature
        ).endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let languageParameter = sut.parameters!["language"] as! String
        let responseFormatParameter = sut.parameters!["response_format"] as! String
        let temperatureFormatParameter = sut.parameters!["temperature"] as! Double
        
        XCTAssertEqual(sut.path, "audio/transcriptions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 5)
        XCTAssertEqual(modelParameter, model.rawValue)
        XCTAssertEqual(languageParameter, language)
        XCTAssertEqual(responseFormatParameter, responseFormat.rawValue)
        XCTAssertEqual(temperatureFormatParameter, temperature)
    }
}

