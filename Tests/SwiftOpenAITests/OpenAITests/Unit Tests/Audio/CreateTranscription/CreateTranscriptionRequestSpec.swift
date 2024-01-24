import XCTest
@testable import SwiftOpenAI

final class CreateTranscriptionRequestSpec: XCTestCase {
    private let api = API()

    func testRequest_CreatedWithCorrectHeaders() throws {
        let apiKey = "1234567890"
        let model: OpenAITranscriptionModelType = .whisper
        let language = "en"
        let responseFormat: OpenAIAudioResponseType = .mp3
        let temperature = 1.0
        
        var endpoint = OpenAIEndpoints.createTranscription(
            file: Data(),
            model: model,
            language: language,
            prompt: "",
            responseFormat: responseFormat,
            temperature: temperature
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
