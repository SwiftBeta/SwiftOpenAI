import XCTest
@testable import SwiftOpenAI

final class EmbeddingsAPIClientSpec: XCTestCase {
    private var sut: EmbeddingsRequestProtocol!
    private let model: OpenAIModelType = .embedding(.text_embedding_ada_002)
    private let apiKey = "1234567890"
    private let input = "What day of the wek is it?"
    
    func testAsyncAPIRequest_ParsesValidJSONToEmbeddingsDataModel() async throws {
        let json = loadJSON(name: "embeddings")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.embeddings(model: model, input: input).endpoint
        
        sut = EmbeddingsRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 200)
        
        do {
            let dataModel = try await sut.execute(api: api, apiKey: apiKey, model: model, input: input)
            XCTAssertNotNil(dataModel)
            XCTAssertEqual(dataModel?.object, "list")
            XCTAssertEqual(dataModel?.model, "text-embedding-ada-002")
            XCTAssertEqual(dataModel?.data[0].embedding.count, 1536)
            XCTAssertEqual(dataModel?.data[0].object, "embedding")
            XCTAssertEqual(dataModel?.data[0].embedding[0], 0.0023064255)
            XCTAssertEqual(dataModel?.data[0].embedding[1], -0.009327292)
            XCTAssertEqual(dataModel?.usage.promptTokens, 8)
            XCTAssertEqual(dataModel?.usage.totalTokens, 8)
        } catch {
            XCTFail()
        }
    }
    
    private func stubHTTP(endpoint: Endpoint,
                          json: Data,
                          statusCode: Int) {
        
        URLProtocolMock.completionHandler = { request in
            let response = HTTPURLResponse(url: URL(string: endpoint.path)!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, json)
        }
    }
}
