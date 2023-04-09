import XCTest
@testable import SwiftOpenAI

final class ChatCompletionAPIClientSpec: XCTestCase {
    private var sut: CreateChatCompletionsRequestProtocol!
    private let model: OpenAIModelType = .gpt4(.base)
    private let apiKey = "1234567890"
    private let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?",
                                                    role: .user)]
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let json = loadJSON(name: "chat.completions")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: nil).endpoint
        
        sut = CreateChatCompletionsRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 200)
        
        do {
            let dataModel = try await sut.execute(api: api, apiKey: apiKey, model: model, messages: messages, optionalParameters: nil)
            XCTAssertNotNil(dataModel)
            XCTAssertEqual(dataModel?.id, "chatcmpl-123")
            XCTAssertEqual(dataModel?.object, "chat.completion")
            XCTAssertEqual(dataModel?.created, 1677652288)
            XCTAssertEqual(dataModel?.choices.count, 1)
            XCTAssertEqual(dataModel?.choices[0].index, 0)
            XCTAssertEqual(dataModel?.choices[0].message.role, "assistant")
            XCTAssertEqual(dataModel?.choices[0].message.content, "Hello there, how may I assist you today?")
            XCTAssertEqual(dataModel?.choices[0].finishReason, "stop")
            XCTAssertEqual(dataModel?.usage.promptTokens, 9)
            XCTAssertEqual(dataModel?.usage.completionTokens, 12)
            XCTAssertEqual(dataModel?.usage.totalTokens, 21)
        } catch {
            XCTFail()
        }
    }
    
    func testAsyncAPIRequest_ParsesValidErrorJSONToErrorDataModel() async throws {
        let json = loadJSON(name: "chat.completions.error.invalid_api_key")
        
        let api = API(requester: RequesterMock())
        let endpoint = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: nil).endpoint
        
        sut = CreateChatCompletionsRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 401)
        
        do {
            let _ = try await sut.execute(api: api, apiKey: apiKey, model: model, messages: messages, optionalParameters: nil)
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
