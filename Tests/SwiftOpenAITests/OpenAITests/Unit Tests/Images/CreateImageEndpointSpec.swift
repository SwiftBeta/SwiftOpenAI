import XCTest
@testable import SwiftOpenAI

final class CreateImageEndpointSpec: XCTestCase {    
    func testChatEndpointCreateImage_WithAllParameters_CreatesCorrectEndpointParameters() throws {
        let prompt = "Pixar style 3D render of a baby hippo, 4k, high resolution, trending in artstation"
        let n = 1
        let size: ImageSize = .s1024
        let sut = OpenAIEndpoints.createImage(model: .dalle(.dalle3), prompt: prompt, numberOfImages: n, size: size).endpoint
        
        XCTAssertEqual(sut.path, "images/generations")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 4)
        XCTAssertEqual(sut.parameters?["prompt"] as! String, prompt)
        XCTAssertEqual(sut.parameters?["n"] as! Int, n)
        XCTAssertEqual(sut.parameters?["size"] as! String, size.rawValue)
    }
}

