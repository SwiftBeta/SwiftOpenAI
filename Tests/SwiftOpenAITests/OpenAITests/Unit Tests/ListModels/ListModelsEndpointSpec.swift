import XCTest
@testable import SwiftOpenAI

final class ListModelsEndpointSpec: XCTestCase {
    func testEndpointListModels() throws {
        let sut = OpenAIEndpoints.listModels.endpoint
        
        XCTAssertEqual(sut.path, "models")
        XCTAssertEqual(sut.method, .GET)
    }
}

