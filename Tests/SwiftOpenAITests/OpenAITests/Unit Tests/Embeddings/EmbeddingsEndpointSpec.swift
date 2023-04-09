import XCTest
@testable import SwiftOpenAI

final class EmbeddingsEndpointSpec: XCTestCase {
    func testEndpointCompletions_WithEmbeddingADA002ModelInput_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .embedding(.text_embedding_ada_002)
        let input = "What day of the wek is it?"
        
        let sut = OpenAIEndpoints.embeddings(model: model, input: input).endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let inputParameter = sut.parameters!["input"] as! String
        
        XCTAssertEqual(sut.path, "embeddings")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 2)
        XCTAssertEqual(modelParameter, model.name)
        XCTAssertEqual(inputParameter, input)
    }
}

