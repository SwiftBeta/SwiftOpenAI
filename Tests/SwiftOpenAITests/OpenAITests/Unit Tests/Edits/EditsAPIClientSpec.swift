import XCTest
@testable import SwiftOpenAI

final class EditsAPIClientSpec: XCTestCase {
    private var sut: EditsRequestProtocol!
    private let model: OpenAIModelType = .edit(.text_davinci_edit_001)
    private let apiKey = "1234567890"
    private let input = "What day of the wek is it?"
    private let instruction = "Fix the spelling mistakes"
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let json = loadJSON(name: "edits")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.edits(model: model, input: input, instruction: instruction).endpoint
        
        sut = EditsRequest()
        
        stubHTTP(model: model,
                 endpoint: endpoint,
                 json: json,
                 statusCode: 200)
        
        do {
            let dataModel = try await sut.execute(api: api, apiKey: apiKey, model: model, input: input, instruction: instruction)
            XCTAssertNotNil(dataModel)
            XCTAssertEqual(dataModel?.object, "edit")
            XCTAssertEqual(dataModel?.created, 1589478378)
            XCTAssertEqual(dataModel?.choices.count, 1)
            XCTAssertEqual(dataModel?.choices[0].index, 0)
            XCTAssertEqual(dataModel?.choices[0].text, "What day of the week is it?")
            XCTAssertEqual(dataModel?.choices[0].index, 0)
            XCTAssertEqual(dataModel?.usage.promptTokens, 25)
            XCTAssertEqual(dataModel?.usage.completionTokens, 32)
            XCTAssertEqual(dataModel?.usage.totalTokens, 57)
        } catch {
            XCTFail()
        }
    }
    
    private func stubHTTP(model: OpenAIModelType,
                          endpoint: Endpoint,
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
