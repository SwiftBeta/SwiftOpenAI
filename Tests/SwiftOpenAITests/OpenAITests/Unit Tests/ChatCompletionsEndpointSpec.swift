import XCTest
@testable import SwiftOpenAI

final class ChatCompletionsEndpointSpec: XCTestCase {
    private var api = API()
    
    func testChatEndpointCreation_WithGPT4ModelAndMessages_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .gpt4(.base)
        let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?", role: "user")]
        let sut = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: nil).endpoint
        
        let firstParameterValue = sut.parameters!["model"] as! String
        let secondParameter = sut.parameters!["messages"] as! [[String : String]]
        
        XCTAssertEqual(sut.path, "chat/completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 8)
        XCTAssertEqual(firstParameterValue, model.name)
        XCTAssertEqual(secondParameter[0]["role"], messages[0].role)
        XCTAssertEqual(secondParameter[0]["content"], messages[0].text)
    }
    
    func testChatEndpointCreation_WithGPT3_5ModelAndMessages_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .gpt3_5(.turbo)
        let messages: [MessageChatGPT] = [.init(text: "Generate 5 questions about Swift", role: "user")]
        let sut = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: nil).endpoint
        
        let firstParameterValue = sut.parameters!["model"] as! String
        let secondParameter = sut.parameters!["messages"] as! [[String : String]]
        
        XCTAssertEqual(sut.path, "chat/completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 8)
        XCTAssertEqual(firstParameterValue, model.name)
        XCTAssertEqual(secondParameter[0]["role"], messages[0].role)
        XCTAssertEqual(secondParameter[0]["content"], messages[0].text)
    }
}

