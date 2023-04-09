import XCTest
@testable import SwiftOpenAI

final class ModerationsEndpointSpec: XCTestCase {
    func testEndpointModerations_WithInput_CreatesCorrectEndpointParameters() throws {
        let input = "Some potentially harmful or explicit content."
        
        let sut = OpenAIEndpoints.moderations(input: input).endpoint
        
        let inputParameter = sut.parameters!["input"] as! String
        
        XCTAssertEqual(sut.path, "moderations")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 1)
        XCTAssertEqual(inputParameter, input)
    }
}

