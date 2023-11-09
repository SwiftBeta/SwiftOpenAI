import XCTest
@testable import SwiftOpenAI

final class CreateImageRequestSpec: XCTestCase {
    private let api = API()
    
    func testRequest_CreatedWithCorrectHeaders() throws {
        let apiKey = "1234567890"
        
        let prompt = "Pixar style 3D render of a baby hippo, 4k, high resolution, trending in artstation"
        let n = 4
        let size: ImageSize = .s1024
        var endpoint = OpenAIEndpoints.createImage(model: .dalle(.dalle2), prompt: prompt, numberOfImages: n, size: size).endpoint
        
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
