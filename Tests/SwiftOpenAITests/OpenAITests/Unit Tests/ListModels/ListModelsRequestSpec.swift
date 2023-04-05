import XCTest
@testable import SwiftOpenAI

final class ListModelsRequestSpec: XCTestCase {
    private let api = API()

    func testRequest_CreatedWithCorrectHeaders() throws {
        let apiKey = "1234567890"
        
        var endpoint = OpenAIEndpoints.listModels.endpoint
        
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
