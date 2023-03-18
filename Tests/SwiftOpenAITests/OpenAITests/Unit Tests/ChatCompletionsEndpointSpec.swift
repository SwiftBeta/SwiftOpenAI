import XCTest
@testable import SwiftOpenAI

class ChatCompletionsEndpointSpec: XCTestCase {
    var api = API()
    
    func testEndpoint_CreatedWithCorrectParameters() throws {
        let model: OpenAIModelType = .gpt4(.base)
        let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?", role: "user")]
        let sut = OpenAIEndpoints.chat(model: model, messages: messages).endpoint
        
        let firstParameterValue = sut.parameters!["model"] as! String
        let secondParameter: [[String: String]] = sut.parameters!["messages"] as! [[String : String]]
        
        XCTAssertEqual(sut.path, "chat/completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 2)
        XCTAssertEqual(firstParameterValue, model.name)
        XCTAssertEqual(secondParameter[0]["role"], messages[0].role)
        XCTAssertEqual(secondParameter[0]["content"], messages[0].text)
    }
    
    func testRequest_CreatedWithCorrectHeaders() throws {
        let apiKey = "1234567890"
        let model: OpenAIModelType = .gpt4(.base)
        let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?", role: "user")]
        var endpoint = OpenAIEndpoints.chat(model: model, messages: messages).endpoint
        
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())
        
        var sut = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &sut,
                       headers: ["Content-Type" : "application/json",
                                 "Authorization" : "Bearer \(apiKey)"])
        
        XCTAssertEqual(sut.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(sut.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(sut.allHTTPHeaderFields?["Authorization"], "Bearer 1234567890")
    }
    
    func testParser_JSONToDataModel_WhenURLRequestIsExecuted() async throws {
        let data =
        """
        {
          "id": "chatcmpl-123",
          "object": "chat.completion",
          "created": 1677652288,
          "choices": [{
            "index": 0,
            "message": {
              "role": "assistant",
              "content": "Hello there, how may I assist you today?",
            },
            "finish_reason": "stop"
          }],
          "usage": {
            "prompt_tokens": 9,
            "completion_tokens": 12,
            "total_tokens": 21
          }
        }
        """.data(using: .utf8)!
        
        let apiKey = "1234567890"
        let model: OpenAIModelType = .gpt4(.base)
        let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?", role: "user")]
        var endpoint = OpenAIEndpoints.chat(model: model, messages: messages).endpoint
        
        api = API(requester: RequesterMock())
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())
        
        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type" : "application/json",
                                 "Authorization" : "Bearer \(apiKey)"])
        
        URLProtocolMock.completionHandler = { request in
            let response = HTTPURLResponse(url: URL(string: endpoint.path)!, statusCode: 200, httpVersion: nil, headerFields: [:])!
            return (response, data)
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
        let result = await api.execute(with: urlRequest)
        let dataModel = try! api.parse(result, type: ChatCompletionDataModel.self, jsonDecoder: jsonDecoder)
        
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
    }
}

