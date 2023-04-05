import XCTest
@testable import SwiftOpenAI

final class EditsRequestSpec: XCTestCase {
    private let api = API()

    func testRequest_CreatedWithCorrectHeaders() throws {
        let apiKey = "1234567890"
        let model: OpenAIModelType = .edit(.text_davinci_edit_001)
        let input = "What day of the wek is it?"
        let instruction = "Fix the spelling mistakes"
        
        var endpoint = OpenAIEndpoints.edits(model: model, input: input, instruction: instruction).endpoint
        
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
