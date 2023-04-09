import XCTest
@testable import SwiftOpenAI

final class EmbeddingsParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToEmbeddingsDataModel() async throws {
        let jsonData = loadJSON(name: "embeddings")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: EmbeddingResponseDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.object, "list")
        XCTAssertEqual(dataModel?.model, "text-embedding-ada-002")
        XCTAssertEqual(dataModel?.data[0].embedding.count, 1536)
        XCTAssertEqual(dataModel?.data[0].object, "embedding")
        XCTAssertEqual(dataModel?.data[0].embedding[0], 0.0023064255)
        XCTAssertEqual(dataModel?.data[0].embedding[1], -0.009327292)
        XCTAssertEqual(dataModel?.usage.promptTokens, 8)
        XCTAssertEqual(dataModel?.usage.totalTokens, 8)
    }
}
