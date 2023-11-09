import XCTest
@testable import SwiftOpenAI

final class ListModelsAPIClientSpec: XCTestCase {
    private var sut: ListModelsRequestProtocol!
    private let model: OpenAIModelType = .gpt4(.base)
    private let apiKey = "1234567890"
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let json = loadJSON(name: "models")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.listModels.endpoint
        
        sut = ListModelsRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 200)
        
        do {
            let dataModel = try await sut.execute(api: api, apiKey: apiKey)
            XCTAssertNotNil(dataModel)
            XCTAssertEqual(dataModel?.data.count, 66)
            XCTAssertEqual(dataModel?.data[0].object, "model")
            XCTAssertEqual(dataModel?.data[0].id, "babbage")
            XCTAssertEqual(dataModel?.data[0].created, 1649358449)
            XCTAssertEqual(dataModel?.data[0].ownedBy, "openai")
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
