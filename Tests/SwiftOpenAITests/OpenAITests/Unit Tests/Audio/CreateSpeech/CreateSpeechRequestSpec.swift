import XCTest
@testable import SwiftOpenAI

final class CreateSpeechRequestSpec: XCTestCase {
    private let api = API()

    func testRequest_CreatedWithCorrectHeaders() throws {
        let apiKey = "1234567890"
        let model: OpenAITTSModelType = .tts(.tts1)
        let input = "Please create an audio with this input"
        let voice: OpenAIVoiceType = .alloy
        let responseFormat: OpenAIAudioResponseType = .mp3
        let speed = 1.0
        
        var endpoint = OpenAIEndpoints.createSpeech(
            model: model,
            input: input,
            voice: voice,
            responseFormat: responseFormat,
            speed: speed
        ).endpoint
        
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())
        
        var sut = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &sut,
                       headers: ["Content-Type" : "application/json",
                                 "Authorization" : "Bearer \(apiKey)"])
        
        XCTAssertEqual(sut.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(sut.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(sut.allHTTPHeaderFields?["Authorization"], "Bearer 1234567890")
    }
}
