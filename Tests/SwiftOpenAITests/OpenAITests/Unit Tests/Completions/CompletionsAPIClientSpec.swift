import XCTest
@testable import SwiftOpenAI

final class CompletionAPIClientSpec: XCTestCase {
    private var sut: CompletionsRequestProtocol!
    private let model: OpenAIModelType = .gpt3_5(.gpt_3_5_turbo_1106)
    private let apiKey = "1234567890"
    private let optionalParameters: CompletionsOptionalParameters = .init(prompt: "Say this is a test")
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let json = loadJSON(name: "completions")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.completions(model: model, optionalParameters: optionalParameters).endpoint
        
        sut = CompletionsRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 200)
        
        do {
            let dataModel = try await sut.execute(api: api, apiKey: apiKey, model: model, optionalParameters: optionalParameters)
            XCTAssertNotNil(dataModel)
            XCTAssertEqual(dataModel?.id, "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7")
            XCTAssertEqual(dataModel?.object, "text_completion")
            XCTAssertEqual(dataModel?.created, 1589478378)
            XCTAssertEqual(dataModel?.choices.count, 1)
            XCTAssertEqual(dataModel?.choices[0].index, 0)
            XCTAssertEqual(dataModel?.choices[0].text, "\n\nThis is indeed a test")
            XCTAssertEqual(dataModel?.choices[0].index, 0)
            XCTAssertEqual(dataModel?.choices[0].finishReason, "length")
            XCTAssertEqual(dataModel?.usage.promptTokens, 5)
            XCTAssertEqual(dataModel?.usage.completionTokens, 7)
            XCTAssertEqual(dataModel?.usage.totalTokens, 12)
        } catch {
            XCTFail()
        }
    }
    
    func testAsyncAPIRequest_ParsesValidErrorJSONToErrorDataModel() async throws {
        let json = loadJSON(name: "completions.error.invalid_api_key")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.completions(model: model, optionalParameters: optionalParameters).endpoint
        
        sut = CompletionsRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 401)
        
        do {
            let _ = try await sut.execute(api: api, apiKey: apiKey, model: model, optionalParameters: optionalParameters)
            XCTFail()
        } catch let error as OpenAIAPIError {
            XCTAssertNotNil(error)
            XCTAssertEqual(error.code, "invalid_api_key")
            XCTAssertEqual(error.message, "Incorrect API key provided: YOUR_API_KEY. You can find your API key at https://platform.openai.com/account/api-keys.")
            XCTAssertEqual(error.type, "invalid_request_error")
            XCTAssertEqual(error.param, "")
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
